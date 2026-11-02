function __project_list
    set -l entries (zoxide query -l -s); or return 1
    printf '%s\n' $entries |
        awk -v prefix="$PROJECTS/" '
            {
                path = $0
                sub(/^ *[0-9.]+ +/, "", path)
                if (index(path, prefix) != 1) next
                rel = substr(path, length(prefix) + 1)
                slash = index(rel, "/")
                if (slash == 0 || index(substr(rel, slash + 1), "/")) next
                print $1 "\t" rel
            }' |
        sort -rnk1
end
