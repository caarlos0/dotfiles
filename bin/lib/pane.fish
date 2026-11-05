function open_pane -a mode
    set -e argv[1]

    if not set -q REX_SESSION; or test -z "$REX_SESSION"; or not command -q rex
        echo "error: --tab and --split require Rex and an active Rex session" >&2
        return 1
    end

    set -l args run -s "$REX_SESSION" -c "$PWD" --focus=false --shell=none
    if test "$mode" = split
        set -a args --split=right
        if set -q REX_BLOCK; and test -n "$REX_BLOCK"
            set -a args -b "$REX_BLOCK"
        end
    end
    rex $args -- $argv
end
