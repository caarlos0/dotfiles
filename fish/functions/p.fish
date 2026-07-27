function p --description "Switch to a project directory"
    set -l query $argv[1]
    set -l ratio_threshold 3

    # One `zoxide` dump instead of one query per org folder: 4 processes
    # instead of ~20, which measures 4-25x faster depending on machine load.
    # zoxide also drops entries whose directory is gone, so `find` is redundant.
    # Lines are "<score>\t<org>/<name>"; the score is dropped after sorting.
    set -l results (
        zoxide query -l -s |
        awk -v prefix="$PROJECTS/" '
            {
                path = $0
                sub(/^ *[0-9.]+ +/, "", path) # strip the score off the path
                if (index(path, prefix) != 1) next # keep only ~/Developer/*
                rel = substr(path, length(prefix) + 1)
                slash = index(rel, "/")
                # keep only org/name: drop the bare org and deeper subfolders
                if (slash == 0 || index(substr(rel, slash + 1), "/")) next
                print $1 "\t" rel
            }' |
        sort -rnk1
    )
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
