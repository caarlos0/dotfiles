set -x NIXPKGS_ALLOW_UNFREE 1

fish_add_path -p \
    $HOME/.bin \
    $GOPATH/bin \
    $HOME/.cargo/bin \
    $HOME/.nix-profile/bin \
    /nix/var/nix/profiles/default/bin \
    /usr/local/go/bin

if test -f ~/.localrc.fish
    source ~/.localrc.fish
end
