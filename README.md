# dotfiles.nix

This is my latest dotfiles generation.

I've been experimenting with many different tools to manage them properly, from
ansible to shell scripts, and never liked any of them that much, to be honest.

You can see the history on these repositories:

- [dotfiles](https://github.com/caarlos0/dotfiles)
- [dotfiles.fish](https://github.com/caarlos0/dotfiles.fish)

This is my latest attempt, using nix.

# What's different

Not much, this is roughly a translation from the latest state of
`dotfiles.fish`, although some parts are still missing (pending me learning
nix-darwin), and others are a bit differet, like the way Fish and Neovim are set
up.

Other than that, more of the same...

# Preparing

1. Install nix and home-manager.
1. Enable some experimental features:
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

# Applying


## macOS

```bash
home-manager switch --flake '.#carlos@supernova'
```


## Linux

```bash
home-manager switch --flake '.#carlos@darkstar'
```

## On both

Home-manager will not change your default shell, so you need to do it yourself.

```bash
fish
which fish | sudo tee -a /etc/shells
chsh -s (which fish)
```

# Update packages

```bash
nix flake update
```

And run the `switch` command again.

# TODO

- [ ] postgres module
- [ ] set-defaults
- [ ] maybe move most of the functions to bin?
- [ ] yubikey
- [ ] code of conduct, license, etc
- [ ] better organize ./modules/dev/

