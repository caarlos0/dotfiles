function p --description "Switch to a project directory"
    set -l query $argv[1]
    set -l ratio_threshold 3

    set -l results (__project_list); or return 1
    test -z "$results" && return 0

    if test -n "$query"
        set results (printf '%s\n' $results | fzf --no-sort --filter="$query")
        set -l scores (printf '%s\n' $results | cut -f1)
        if test (count $scores) -ge 1
            set -l top $scores[1]
            set -l second 0
            test (count $scores) -ge 2 && set second $scores[2]
            if test $second -eq 0; or test (math "$top / $second") -ge $ratio_threshold
                set selected (printf '%s\n' $results[1] | cut -f2)
            end
        end
    end

    if test -z "$selected"
        set selected (printf '%s\n' $results | cut -f2 | fzf --no-sort --select-1 --query="$query" --prompt="  ")
    end

    test -z "$selected" && return 0
    zoxide add "$PROJECTS/$selected"
    cd "$PROJECTS/$selected"
end
