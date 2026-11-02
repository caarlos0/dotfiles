#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
tmp=$(CDPATH= cd -- "$tmp" && pwd -P)
trap 'rm -rf "$tmp"' EXIT

export HOME="$tmp/home"
export PATH="$tmp/bin:$PATH"
mkdir -p "$HOME/Developer/worktrees/repo" "$tmp/bin"

git init -q --bare "$tmp/repo.git"
git init -q -b main "$tmp/source"
git -C "$tmp/source" config user.name "Test"
git -C "$tmp/source" config user.email "test@example.com"
git -C "$tmp/source" commit -q --allow-empty -m initial
git -C "$tmp/source" branch aurora
git -C "$tmp/source" remote add origin "$tmp/repo.git"
git -C "$tmp/source" push -q origin main aurora
git clone -q --single-branch --branch main "$tmp/repo.git" "$tmp/repo"
git -C "$tmp/repo" worktree add -q --detach "$HOME/Developer/worktrees/repo/aurora"

cat >"$tmp/bin/gh" <<'EOF'
#!/bin/sh
set -e
case "$*" in
    'pr view 148 --json headRefName --jq .headRefName') echo aurora ;;
    'pr view 148 --json isCrossRepository --jq .isCrossRepository') echo false ;;
    'pr checkout 148')
        git fetch -q origin
        git switch -q -c aurora --track origin/aurora
        ;;
    *) echo "unexpected gh arguments: $*" >&2; exit 1 ;;
esac
EOF
chmod +x "$tmp/bin/gh"

cd "$tmp/repo"
WT_POST_CMD=1 "$root/bin/wt" -p 148
branch=$(git -C "$HOME/Developer/worktrees/repo/aurora" branch --show-current)
test "$branch" = aurora || {
    echo "expected branch aurora, got '$branch'" >&2
    exit 1
}
