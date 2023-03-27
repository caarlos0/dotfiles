set -U fish_greeting
set -x GPG_TTY (tty)
set -x NIXPKGS_ALLOW_UNFREE 1

fish_add_path -a $HOME/.bin $GOPATH/bin /usr/local/go/bin $HOME/.cargo/bin

function __trap_exit_tmux
    test -z "$NVIM_LISTEN_ADDRESS" || exit
    test -z "$NVIM" || exit
    test (tmux list-windows | count) = 1 || exit
    test (tmux list-panes | count) = 1 || exit
    tmux switch-client -t default
end

if status --is-interactive
    trap __trap_exit_tmux EXIT
end
