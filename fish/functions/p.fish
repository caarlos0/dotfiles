function p --description "Switch to a project directory"
    set -l query $argv[1]
    set -l selected (
        find "$PROJECTS" -maxdepth 1 -type d |
        while read dir
            zoxide query -l -s "$dir/"
        end |
        sed "s;$PROJECTS/;;" |
        grep -v "$PROJECTS" |
        grep / |
        sort -rnk1 |
        uniq |
        awk '{print $2}' |
        fzf --no-sort --select-1 --query="$query" --prompt="  "
    )
    test -z "$selected" && return 0
    zoxide add "$PROJECTS/$selected"
    cd "$PROJECTS/$selected"
end
