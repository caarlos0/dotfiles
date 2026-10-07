import os
from pathlib import Path
import subprocess
import tempfile
import unittest


SETUP = (Path(__file__).resolve().parents[2] / "setup").read_text()
LINK = SETUP.split("link() {", 1)[1].split('\ninfo "Setting', 1)[0]
EXTENSIONS = SETUP.split(
    "# Remove only links to this checkout's retired extensions.\n", 1
)[1].split('link "$PWD"/gh-dash/', 1)[0]


class ExtensionSetupTest(unittest.TestCase):
    def test_migration_only_removes_this_checkouts_links(self):
        for kind in ("managed", "other-link", "directory", "file", "absent"):
            with self.subTest(kind=kind):
                with tempfile.TemporaryDirectory(
                    dir=os.environ.get("TMPDIR")
                ) as tmp:
                    root = Path(tmp)
                    checkout = root / "dotfiles"
                    source = checkout / "gh/extensions"
                    current = source / "gh-wait"
                    current.mkdir(parents=True)
                    executable = current / "gh-wait"
                    executable.write_text("#!/bin/sh\n")
                    executable.chmod(0o700)
                    home = root / "home"
                    installed = home / ".local/share/gh/extensions"
                    installed.mkdir(parents=True)
                    retired = [installed / name for name in (
                        "gh-wait-push", "gh-wait-review"
                    )]
                    other = root / "other-extension"
                    other.mkdir()
                    for path in retired:
                        # Deleted files can leave empty directories in a checkout.
                        (source / path.name).mkdir()
                        if kind == "managed":
                            path.symlink_to(source / path.name)
                        elif kind == "other-link":
                            path.symlink_to(other)
                        elif kind == "directory":
                            path.mkdir()
                            (path / "keep").write_text("keep")
                        elif kind == "file":
                            path.write_text("keep")
                    unrelated = installed / "gh-other"
                    unrelated.symlink_to(other)

                    for _ in range(2):
                        result = subprocess.run(
                            ["/bin/bash", "-e", "-c",
                             "success() { :; }\nwarn() { :; }\n"
                             + "link() {" + LINK + "\n" + EXTENSIONS],
                            cwd=checkout,
                            env={
                                "HOME": str(home),
                                "PWD": str(checkout),
                                "PATH": "/usr/bin:/bin",
                            },
                            capture_output=True,
                            text=True,
                            timeout=10,
                        )
                        self.assertEqual(
                            result.returncode, 0, result.stdout + result.stderr
                        )
                        self.assertEqual(
                            (installed / "gh-wait").readlink(), current
                        )
                        self.assertEqual(unrelated.readlink(), other)
                        for path in retired:
                            if kind in ("managed", "absent"):
                                self.assertFalse(path.exists())
                                self.assertFalse(path.is_symlink())
                            elif kind == "other-link":
                                self.assertEqual(path.readlink(), other)
                            elif kind == "directory":
                                self.assertEqual((path / "keep").read_text(), "keep")
                            else:
                                self.assertEqual(path.read_text(), "keep")


if __name__ == "__main__":
    unittest.main()
