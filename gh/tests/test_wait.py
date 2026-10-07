import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "extensions/gh-wait/gh-wait"
URL = "https://github.example/owner/repo/pull/123"
REPO_URL = "https://github.example/owner/repo"
OPEN = 'OPEN {"state":"OPEN","headRefOid":"old","reviews":{"nodes":[]}}'

# Script the external commands, not the waiter's polling or event logic.
TOOL = """
import json
from pathlib import Path
import sys

path = Path("steps.json")
steps = json.loads(path.read_text())
args = [Path(sys.argv[0]).name, *sys.argv[1:]]
if not steps:
    sys.exit("unexpected command: " + repr(args))
step = steps.pop(0)
path.write_text(json.dumps(steps))
if args[:len(step["args"])] != step["args"]:
    sys.exit("expected " + repr(step["args"]) + ", got " + repr(args))
for value in step.get("contains", []):
    if not any(value in arg for arg in args):
        sys.exit("missing " + repr(value) + " in " + repr(args))
sys.stdout.write(step.get("out", ""))
sys.stderr.write(step.get("err", ""))
sys.exit(step.get("code", 0))
"""


def step(args, out="", *, code=0, err="", contains=()):
    return dict(args=args, out=out, code=code, err=err, contains=contains)


def target(operand="123"):
    return step(
        ["gh", "pr", "view"],
        f"PR_id {URL}\n",
        contains=["--json", "id,url", "--", operand] if operand else ["id,url"],
    )


def snapshot(out=OPEN, **kwargs):
    return step(
        ["gh", "api", "graphql", "--hostname", "github.example"],
        out + "\n",
        contains=[
            "--paginate", "id=PR_id", "updatedAt", "title body",
            "headRefOid", "baseRefName baseRefOid isDraft",
            "nodes { id updatedAt body state submittedAt }",
            "after: $endCursor", "pageInfo { hasNextPage endCursor }",
        ],
        **kwargs,
    )


def state(out="OPEN", **kwargs):
    return step(["gh", "pr", "view", URL, "--json", "state"], out, **kwargs)


def sleep():
    return step(["sleep", "30"])


def repo(branch="main"):
    return step(
        ["gh", "repo", "view"],
        f"REPO_id {REPO_URL} {branch}\n",
        contains=["id,url,defaultBranchRef"],
    )


def head(out="old", branch="main", **kwargs):
    return step(
        ["gh", "api", "graphql", "--hostname", "github.example"],
        out,
        contains=["id=REPO_id", f"ref=refs/heads/{branch}", "target { oid }"],
        **kwargs,
    )


class WaitTest(unittest.TestCase):
    def run_wait(self, args, steps, *, code=0, out="", err=""):
        with tempfile.TemporaryDirectory(dir=os.environ.get("TMPDIR")) as tmp:
            root = Path(tmp)
            tools = root / "bin"
            tools.mkdir()
            for name in ("gh", "git", "sleep"):
                tool = tools / name
                tool.write_text(f"#!{sys.executable}\n{TOOL}")
                tool.chmod(0o700)
            (root / "steps.json").write_text(json.dumps(steps))
            result = subprocess.run(
                ["/bin/sh", str(SCRIPT), *args],
                cwd=root,
                env={
                    "PATH": f"{tools}:/usr/bin:/bin",
                    "HOME": str(root),
                    "GH_CONFIG_DIR": str(root / "config"),
                    "GH_REPO": "github.example/owner/repo",
                    "LC_ALL": "C",
                },
                stdin=subprocess.DEVNULL,
                capture_output=True,
                text=True,
                timeout=10,
            )
            context = f"args={args}\nstdout={result.stdout}\nstderr={result.stderr}"
            self.assertEqual(result.returncode, code, context)
            if out is not None:
                self.assertEqual(result.stdout, out, context)
            self.assertEqual(result.stderr, err, context)
            self.assertEqual(
                json.loads((root / "steps.json").read_text()), [], context
            )
            return result

    def test_help_without_external_commands(self):
        for args in (["--help"], ["-h"], ["123", "--help"]):
            with self.subTest(args=args):
                result = self.run_wait(args, [], out=None)
                self.assertIn("Usage: gh wait", result.stdout)
                self.assertIn("--merge", result.stdout)

    def test_invalid_usage(self):
        for args, message in (
            (["--wat"], "unknown option: --wat"),
            (["--push", "old"], "unknown option: --push"),
            (["--review"], "unknown option: --review"),
            (["123", "--wat"], "unknown option: --wat"),
            (["123", "456"], "expected one nonempty PR"),
            (["123", "--", "456"], "expected one nonempty PR"),
            (["--", "123", "456"], "expected one nonempty PR"),
            ([""], "expected one nonempty PR"),
        ):
            with self.subTest(args=args):
                self.run_wait(
                    args, [], code=2, err=f"{message} (see gh wait --help)\n"
                )

    def test_pr_selectors_and_end_of_options(self):
        for operand in ("123", URL, "topic", "-topic"):
            with self.subTest(operand=operand):
                self.run_wait(
                    ["--", operand],
                    [target(operand), snapshot('MERGED {"state":"MERGED"}')],
                    out=f"merged\t{URL}\n",
                )

    def test_changes_after_unchanged_poll(self):
        for field, value in (
            ("updatedAt", "later"),
            ("title", "edited"),
            ("body", "edited"),
            ("headRefOid", "new"),
            ("baseRefName", "release"),
            ("baseRefOid", "new"),
            ("isDraft", True),
            ("reviews", {"nodes": [{"state": "APPROVED"}]}),
            ("reviews", {"nodes": [{"body": "edited"}]}),
        ):
            with self.subTest(field=field, value=value):
                data = json.loads(OPEN.split(" ", 1)[1])
                data[field] = value
                changed = "OPEN " + json.dumps(data)
                self.run_wait(
                    ["123"],
                    [
                        target(), snapshot(), sleep(), snapshot(),
                        sleep(), snapshot(changed),
                    ],
                    out=f"changed\t{URL}\n",
                )

    def test_change_on_later_review_page(self):
        first = OPEN + "\n"
        self.run_wait(
            ["123"],
            [
                target(), snapshot(first + 'OPEN {"review":"old"}'), sleep(),
                snapshot(first + 'OPEN {"review":"edited"}'),
            ],
            out=f"changed\t{URL}\n",
        )

    def test_terminal_events(self):
        for terminal in ("MERGED", "CLOSED"):
            for immediate in (True, False):
                with self.subTest(terminal=terminal, immediate=immediate):
                    steps = [target()]
                    if not immediate:
                        steps += [snapshot(), sleep()]
                    steps += [snapshot(f'{terminal} {{"state":"{terminal}"}}')]
                    self.run_wait(
                        ["123"], steps, out=f"{terminal.lower()}\t{URL}\n"
                    )

    def test_merge_only_and_option_order(self):
        for args in (["--merge", "123"], ["123", "--merge"]):
            with self.subTest(args=args):
                self.run_wait(
                    args,
                    [target(), state(), sleep(), state(), sleep(), state("MERGED")],
                    out=f"merged\t{URL}\n",
                )

    def test_merge_already_complete(self):
        self.run_wait(
            ["--merge", "123"], [target(), state("MERGED")],
            out=f"merged\t{URL}\n",
        )

    def test_merge_closed_without_merging(self):
        self.run_wait(
            ["--merge", "123"], [target(), state(), sleep(), state("CLOSED")],
            code=1, err=f"pull request closed without merging: {URL}\n",
        )

    def test_merge_without_pr_skips_branch_detection(self):
        self.run_wait(
            ["--merge"], [target(""), state("MERGED")],
            out=f"merged\t{URL}\n",
        )

    def test_default_branch_compares_local_head(self):
        for branch in ("main", "trunk"):
            for immediate in (True, False):
                with self.subTest(branch=branch, immediate=immediate):
                    steps = [
                        step(["git", "symbolic-ref", "--quiet", "--short", "HEAD"], branch),
                        repo(branch), step(["git", "rev-parse", "HEAD"], "old"),
                    ]
                    if not immediate:
                        steps += [head(branch=branch), sleep()]
                    steps += [head("new", branch)]
                    self.run_wait([], steps, out=f"commits\t{REPO_URL}/commit/new\n")

    def test_feature_branch_uses_current_pr(self):
        self.run_wait(
            [],
            [
                step(["git", "symbolic-ref", "--quiet", "--short", "HEAD"], "topic"),
                repo(), target(""), snapshot(), sleep(),
                snapshot('MERGED {"state":"MERGED"}'),
            ],
            out=f"merged\t{URL}\n",
        )

    def test_detached_head_requires_explicit_pr(self):
        self.run_wait(
            [], [step(["git", "symbolic-ref"], code=1)], code=1,
            err="cannot select a branch; pass a PR number or URL\n",
        )

    def test_api_errors_stop_without_retrying(self):
        failure = dict(code=4, err="authentication failed\n")
        for args, steps in (
            (["123"], [step(["gh", "pr", "view"], **failure)]),
            (["123"], [target(), snapshot("", **failure)]),
            (["123"], [target(), snapshot(), sleep(), snapshot("", **failure)]),
            (["--merge", "123"], [target(), state("", **failure)]),
            (["--merge", "123"], [target(), state(), sleep(), state("", **failure)]),
            ([], [
                step(["git", "symbolic-ref"], "main"), repo(),
                step(["git", "rev-parse", "HEAD"], "old"),
                head(), sleep(), head("", **failure),
            ]),
        ):
            with self.subTest(args=args, steps=steps):
                self.run_wait(args, steps, code=1, err=failure["err"])


if __name__ == "__main__":
    unittest.main()
