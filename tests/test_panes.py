import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
FISH = shutil.which("fish")


@unittest.skipUnless(FISH, "fish is required")
class PaneTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.bin = self.directory / "bin"
        self.bin.mkdir()
        self.env = os.environ.copy()
        for key in ("REX_SESSION", "REX_BLOCK", "TMUX", "WT_PREVIOUS", "WT_PANE", "WT_POST_CMD"):
            self.env.pop(key, None)
        self.env.update(
            HOME=str(self.directory),
            XDG_CONFIG_HOME=str(self.directory / "config"),
            XDG_DATA_HOME=str(self.directory / "data"),
            XDG_CACHE_HOME=str(self.directory / "cache"),
            PATH=f"{self.bin}:/usr/bin:/bin",
            CALL_DIR=str(self.directory),
        )

    def fake(self, name):
        path = self.bin / name
        path.write_text(
            "#!/bin/sh\n"
            f'printf "%s\\0" "$@" >> "$CALL_DIR/{name}"\n'
            f'printf "\\0" >> "$CALL_DIR/{name}"\n'
            'exit "${FAKE_EXIT:-0}"\n'
        )
        path.chmod(0o755)

    def calls(self, name):
        path = self.directory / name
        if not path.exists():
            return []
        return [
            record.decode().split("\0")
            for record in path.read_bytes().split(b"\0\0")
            if record
        ]

    def run_script(self, name, *args):
        return subprocess.run(
            [FISH, str(ROOT / "bin" / name), *args],
            cwd=ROOT,
            env=self.env,
            capture_output=True,
            text=True,
        )

    def test_wt_prefers_rex_and_preserves_arguments(self):
        self.fake("rex")
        self.fake("tmux")
        self.env.update(REX_SESSION="session", REX_BLOCK="block", TMUX="tmux", WT_PREVIOUS="/previous tree")
        result = self.run_script("wt", "fix-login", "--tab", "--", "printf", "a b", "line\nbreak")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.calls("tmux"), [])
        self.assertEqual(self.calls("rex"), [[
            "run", "-s", "session", "-c", str(ROOT), "--focus=false", "--shell=none",
            "--", "env", "WT_PANE=1", "WT_PREVIOUS=/previous tree", str(ROOT / "bin" / "wt"),
            "fix-login", "--", "printf", "a b", "line\nbreak",
        ]])

    def test_wt_rex_split_uses_own_block_when_available(self):
        self.fake("rex")
        self.env.update(REX_SESSION="session", REX_BLOCK="block")
        result = self.run_script("wt", "--split", "--pr", "42", "--", "copilot")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.calls("rex")[0], [
            "run", "-s", "session", "-c", str(ROOT), "--focus=false", "--shell=none",
            "--split=right", "-b", "block", "--", "env", "WT_PANE=1",
            str(ROOT / "bin" / "wt"), "--pr", "42", "--", "copilot",
        ])

    def test_wt_rex_split_without_block_uses_session_focus(self):
        self.fake("rex")
        self.env["REX_SESSION"] = "session"
        result = self.run_script("wt", "fix", "--split")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("-b", self.calls("rex")[0])

    def test_wt_falls_back_to_tmux_without_rex_context_or_executable(self):
        self.fake("tmux")
        for session in (None, "session"):
            with self.subTest(session=session):
                if session is None:
                    self.env.pop("REX_SESSION", None)
                else:
                    self.env["REX_SESSION"] = session
                self.env.update(TMUX="tmux", WT_PREVIOUS="/previous")
                result = self.run_script("wt", "fix", "--split")
                self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.calls("tmux"), [[
            "split-window", "-h", "-d", "-c", str(ROOT), "env", "WT_PANE=1",
            "WT_PREVIOUS=/previous", str(ROOT / "bin" / "wt"), "fix",
        ]] * 2)

    def test_wt_uses_tmux_when_rex_exists_but_has_no_session(self):
        self.fake("rex")
        self.fake("tmux")
        self.env["TMUX"] = "tmux"
        result = self.run_script("wt", "fix", "--tab")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.calls("rex"), [])
        self.assertEqual(self.calls("tmux")[0][:4], ["new-window", "-d", "-c", str(ROOT)])

    def test_wt_runs_command_in_created_worktree(self):
        project = self.directory / "project"
        project.mkdir()
        (project / "file").write_text("content\n")
        for args in (
            ["init", "-q"],
            ["add", "file"],
            ["-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-qm", "initial"],
        ):
            subprocess.run(["git", *args], cwd=project, env=self.env, check=True, capture_output=True)
        (self.bin / "fish").symlink_to(FISH)
        rex = self.bin / "rex"
        rex.write_text('#!/bin/sh\nwhile [ "$1" != "--" ]; do shift; done\nshift\nexec "$@"\n')
        rex.chmod(0o755)
        self.env["REX_SESSION"] = "session"
        result = subprocess.run(
            [FISH, str(ROOT / "bin" / "wt"), "fix", "--tab", "--", "/bin/pwd"],
            cwd=project,
            env=self.env,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            result.stdout.splitlines()[-1],
            str(self.directory / "Developer" / "worktrees" / "project" / "fix"),
        )

    def test_rex_failure_does_not_fall_back_to_tmux(self):
        self.fake("rex")
        self.fake("tmux")
        self.env.update(REX_SESSION="session", TMUX="tmux", FAKE_EXIT="7")
        result = self.run_script("wt", "fix", "--tab")
        self.assertEqual(result.returncode, 7, result.stderr)
        self.assertEqual(self.calls("tmux"), [])

    def test_missing_backend_is_an_error(self):
        result = self.run_script("wt", "fix", "--tab")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("require a Rex session or tmux", result.stderr)

    def test_review_with_no_pr_can_open_rex_split(self):
        self.fake("rex")
        self.env.update(REX_SESSION="session", REX_BLOCK="block")
        result = self.run_script("review", "--split", "--keep")
        self.assertEqual(result.returncode, 0, result.stderr)
        call = self.calls("rex")[0]
        self.assertEqual(call[:11], [
            "run", "-s", "session", "-c", str(ROOT), "--focus=false", "--shell=none",
            "--split=right", "-b", "block", "--",
        ])
        self.assertEqual(call[11], "copilot")
        self.assertIn("Keep reviewing every new push", call[-1])

    def test_review_help_has_no_side_effects(self):
        for name in ("copilot", "wt", "rex", "tmux"):
            self.fake(name)
        self.env.update(REX_SESSION="session", TMUX="tmux")
        for flag in ("--help", "-h"):
            with self.subTest(flag=flag):
                result = self.run_script("review", flag, "--tab", "--split", "12")
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stderr, "")
                for text in ("USAGE:", "--help,-h", "--keep,-k", "--tab,-t", "--split,-s"):
                    self.assertIn(text, result.stdout)
        for name in ("copilot", "wt", "rex", "tmux"):
            self.assertEqual(self.calls(name), [])

    def test_review_routes_multiple_prs_through_wt(self):
        self.fake("wt")
        result = self.run_script("review", "--tab", "12", "34")
        self.assertEqual(result.returncode, 0, result.stderr)
        calls = self.calls("wt")
        self.assertEqual(len(calls), 2)
        self.assertEqual(calls[0][:4], ["--tab", "--pr", "12", "--"])
        self.assertEqual(calls[1][:4], ["--tab", "--pr", "34", "--"])
        self.assertEqual(calls[0][4:], calls[1][4:])

    def test_review_without_pr_or_mode_runs_in_current_pane(self):
        self.fake("copilot")
        result = self.run_script("review")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(self.calls("copilot")), 1)

    def test_review_requires_mode_for_multiple_prs(self):
        result = self.run_script("review", "12", "34")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("several PRs need --tab or --split", result.stderr)


if __name__ == "__main__":
    unittest.main()
