# Keep title at the git root.
function fish_title
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$root"
        basename "$root"
    else
        basename "$PWD"
    end
end
