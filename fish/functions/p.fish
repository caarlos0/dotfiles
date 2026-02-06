function p --description "Switch to a project directory"
    set -l query $argv[1]
    set -l ratio_threshold 3

    set -l results (
        find "$PROJECTS" -maxdepth 1 -type d |
        while read dir
            zoxide query -l -s "$dir/"
        end |
        sed "s;$PROJECTS/;;" |
        grep -v "$PROJECTS" |
        grep / |
        sort -rnk1 |
        uniq
    )
    test -z "$results" && return 0

    if test -n "$query"
        set results (printf '%s\n' $results | fzf --no-sort --filter="$query")
        set -l scores (printf '%s\n' $results | awk '{print $1}')
        if test (count $scores) -ge 1
            set -l top $scores[1]
            set -l second 0
            test (count $scores) -ge 2 && set second $scores[2]
            if test $second -eq 0; or test (math "$top / $second") -ge $ratio_threshold
                set selected (echo $results[1] | awk '{print $2}')
            end
        end
    end

    if test -z "$selected"
        set selected (printf '%s\n' $results | awk '{print $2}' | fzf --no-sort --select-1 --query="$query" --prompt="  ")
    end

    test -z "$selected" && return 0
    zoxide add "$PROJECTS/$selected"
    cd "$PROJECTS/$selected"
end
