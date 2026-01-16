function gp
    set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if test "$branch" = "main"; or test "$branch" = "master"
        read -l -P "Pushing to main - are you sure? [y/N] " confirm
        if not string match -q -i "y" "$confirm"
            echo "Cancelled"
            return
        end
    end
    git push origin HEAD $argv
end
