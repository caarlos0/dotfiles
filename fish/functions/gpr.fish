function gpr
    set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if test "$branch" = "main"; or test "$branch" = "master"
        echo "Cannot open PR from main branch!" >&2
        return 1
    end
    git ppr $argv
end
