import { createServer } from "node:http";
import { readFile, readdir, realpath, stat } from "node:fs/promises";
import { homedir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { parseArgs } from "node:util";
import { validate } from "./board-data.mjs";

class HttpError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
  }
}

async function main() {
  let options;
  try {
    options = parseArgs({
      options: {
        help: { type: "boolean", short: "h" },
        directory: { type: "string", default: join(homedir(), ".local/state/copilot-coordinator") },
        port: { type: "string", default: "8765" },
      },
    }).values;
    if (!/^\d+$/.test(options.port) || Number(options.port) > 65535) {
      throw new Error("--port must be an integer from 0 to 65535.");
    }
  } catch (error) {
    console.error(`${error.message}\nRun with --help for usage.`);
    process.exitCode = 2;
    return;
  }
  if (options.help) {
    console.log(`Serve the coordinator task board on 127.0.0.1.

Usage: node serve.mjs [--directory PATH] [--port PORT]
       bun serve.mjs [--directory PATH] [--port PORT]

  --directory PATH  State directory (default: ~/.local/state/copilot-coordinator)
  --port PORT       Listening port (default: 8765; 0 chooses an available port)
  -h, --help        Show help

Open the printed HTTP URL and choose a coordinator. Stop with Ctrl+C.
No packages are required. Invalid arguments exit 2; startup failures exit 1.`);
    return;
  }

  const configuredDirectory = resolve(options.directory);
  const directory = await realpath(configuredDirectory);
  await readdir(directory);
  const assets = dirname(fileURLToPath(import.meta.url));

  async function localFile(value) {
    if (!value || value.includes("\0")) throw new HttpError(400, "A filename is required.");
    const candidate = resolve(directory, value);
    if (dirname(candidate) !== directory && dirname(candidate) !== configuredDirectory) {
      throw new HttpError(403, "File must be directly inside the configured state directory.");
    }
    const target = await realpath(candidate);
    if (dirname(target) !== directory || !(await stat(target)).isFile()) {
      throw new HttpError(403, "File must be a regular file inside the state directory.");
    }
    return target;
  }

  async function loadBoard(file) {
    if (!file || !/\.json$/i.test(file)) throw new HttpError(400, "Select a JSON handoff.");
    const data = JSON.parse(await readFile(await localFile(file), "utf8"));
    try {
      validate(data);
    } catch (error) {
      throw new HttpError(400, `${file}: ${error.message}`);
    }
    return data;
  }

  async function listBoards() {
    const boards = [];
    const errors = [];
    for (const entry of await readdir(directory, { withFileTypes: true })) {
      const file = entry.name;
      if ((!entry.isFile() && !entry.isSymbolicLink()) ||
          !/-(handoff|reviewer|implementer|coordinator)\.json$/i.test(file) ||
          file.startsWith(".")) continue;
      try {
        const data = JSON.parse(await readFile(await localFile(file), "utf8"));
        validate(data);
        boards.push({
          file,
          path: join(directory, file),
          id: data.id,
          goal: data.goal,
          status: data.status,
          updated_at: data.updated_at,
          task_count: data.tasks.length,
        });
      } catch (error) {
        errors.push({ file, error: error.message });
      }
    }
    boards.sort((a, b) => Date.parse(b.updated_at) - Date.parse(a.updated_at) ||
      a.file.localeCompare(b.file));
    errors.sort((a, b) => a.file.localeCompare(b.file));
    return { directory, boards, errors };
  }

  function send(response, status, body, type = "application/json; charset=utf-8") {
    response.writeHead(status, {
      "Content-Type": type,
      "Cache-Control": "no-store",
      "X-Content-Type-Options": "nosniff",
    });
    response.end(typeof body === "object" && !Buffer.isBuffer(body) ? JSON.stringify(body) : body);
  }

  const server = createServer(async (request, response) => {
    try {
      const port = server.address().port;
      const hosts = [`127.0.0.1:${port}`, `localhost:${port}`];
      if (port === 80) hosts.push("127.0.0.1", "localhost");
      if (!hosts.includes(request.headers.host)) {
        throw new HttpError(403, "Use the printed loopback URL.");
      }
      if (request.method !== "GET") throw new HttpError(405, "Only GET requests are supported.");
      const url = new URL(request.url, `http://127.0.0.1:${port}`);
      if (url.pathname === "/" || url.pathname === "/board.html") {
        send(response, 200, await readFile(join(assets, "board.html")), "text/html; charset=utf-8");
      } else if (url.pathname === "/board-data.mjs") {
        send(response, 200, await readFile(join(assets, "board-data.mjs")), "text/javascript; charset=utf-8");
      } else if (url.pathname === "/api/boards") {
        send(response, 200, await listBoards());
      } else if (url.pathname === "/api/board") {
        send(response, 200, await loadBoard(url.searchParams.get("file")));
      } else if (url.pathname === "/api/artifact") {
        const data = await loadBoard(url.searchParams.get("file"));
        const name = url.searchParams.get("name");
        if (!name || !data.tasks.some((task) => task.brief === name || task.result === name)) {
          throw new HttpError(403, "Artifact is not referenced by the selected handoff.");
        }
        send(response, 200, await readFile(await localFile(name)), "text/plain; charset=utf-8");
      } else {
        throw new HttpError(404, "Not found.");
      }
    } catch (error) {
      const status = error.status || ({ ENOENT: 404, EACCES: 403, EPERM: 403 })[error.code] ||
        (error instanceof SyntaxError ? 400 : 500);
      if (status === 500) console.error(error.message);
      send(response, status, { error: error.message });
    }
  });
  await new Promise((ready, reject) => {
    server.once("error", reject);
    server.listen(Number(options.port), "127.0.0.1", ready);
  });
  console.log(`http://127.0.0.1:${server.address().port}/`);
  process.on("SIGINT", () => server.close(() => { process.exitCode = 130; }));
  process.on("SIGTERM", () => server.close());
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
