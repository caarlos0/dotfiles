export const statuses = ["pending", "running", "verifying", "blocked", "done"];
const runStatuses = ["active", "paused", "blocked", "finished"];

function text(value, field) {
  if (typeof value !== "string" || !value.trim()) {
    throw new Error(`${field} must be a non-empty string.`);
  }
  return value;
}

function timestamp(value, field) {
  text(value, field);
  if (!/(Z|[+-]\d{2}:\d{2})$/.test(value) || !Number.isFinite(Date.parse(value))) {
    throw new Error(`${field} must be a timestamp with a timezone.`);
  }
}

export function artifactName(value, field = "artifact") {
  text(value, field);
  if (!/^[a-zA-Z0-9][a-zA-Z0-9._-]*$/.test(value)) {
    throw new Error(`${field} must be a filename in the state directory.`);
  }
  return value;
}

export function prURL(value) {
  const url = new URL(text(value, "pr"));
  if (url.origin !== "https://github.com" || url.username || url.password ||
      !/^\/[^/]+\/[^/]+\/pull\/\d+$/.test(url.pathname)) {
    throw new Error("pr must be an HTTPS GitHub pull request URL.");
  }
  return url.href;
}

export function validate(data) {
  if (!data || typeof data !== "object" || Array.isArray(data)) {
    throw new Error("Handoff must be a JSON object.");
  }
  text(data.id, "id");
  text(data.goal, "goal");
  timestamp(data.updated_at, "updated_at");
  if (!runStatuses.includes(data.status) || !Array.isArray(data.tasks)) {
    throw new Error("Handoff needs a valid run status and a tasks array.");
  }
  const ids = new Set();
  for (const task of data.tasks) {
    if (!task || typeof task !== "object" || Array.isArray(task)) {
      throw new Error("Each task must be a JSON object.");
    }
    for (const field of ["id", "repository", "goal", "next_action"]) {
      text(task[field], `task.${field}`);
    }
    timestamp(task.updated_at, "task.updated_at");
    if (!statuses.includes(task.status)) {
      throw new Error(`Unknown status for task ${task.id}: ${task.status}`);
    }
    if (ids.has(task.id)) throw new Error(`Duplicate task ID: ${task.id}`);
    ids.add(task.id);
    for (const field of ["worker", "blocker"]) {
      if (task[field] != null) text(task[field], `task.${field}`);
    }
    for (const field of ["brief", "result"]) {
      if (task[field] != null) artifactName(task[field], `task.${field}`);
    }
    if (task.pr != null) prURL(task.pr);
  }
}
