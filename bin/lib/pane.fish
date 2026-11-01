function open_pane -a mode
    set -e argv[1]

    if set -q REX_SESSION; and test -n "$REX_SESSION"; and command -q rex
        set -l args run -s "$REX_SESSION" -c "$PWD" --focus=false --shell=none
        if test "$mode" = split
            set -a args --split=right
            if set -q REX_BLOCK; and test -n "$REX_BLOCK"
                set -a args -b "$REX_BLOCK"
            end
        end
        rex $args -- $argv
    else if set -q TMUX; and test -n "$TMUX"
        if test "$mode" = tab
            tmux new-window -d -c "$PWD" $argv
        else
            tmux split-window -h -d -c "$PWD" $argv
        end
    else
        echo "error: --tab and --split require a Rex session or tmux" >&2
        return 1
    end
end
