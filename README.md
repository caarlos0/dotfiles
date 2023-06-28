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
nix-darwin), and others are a bit different, like the way Fish and neovim are set
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

```bash
task apply
```

On macOS, you may also:

```bash
task apply_darwin
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
task update
```

And run the `switch` command again.

# Clean up

```bash
nix-collect-garbage
```

# TODO

- [x] postgres module
- [x] set-defaults
- [x] maybe move most of the functions to bin?
- [ ] yubikey
- [x] code of conduct, license, etc
- [x] better organize ./modules/dev/
- [x] install wezterm's terminfo with nix, currently just following instructions
      [here](https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines) manually
