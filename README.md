# caarlos0/dotfiles

This is my latest dotfiles generation.

I've been experimenting with many different tools to manage them properly, from
ansible to shell scripts, and never liked any of them that much, to be honest.

You can see the history on these repositories:

- [dotfiles.zsh](https://github.com/caarlos0/dotfiles.zsh)
- [dotfiles.fish](https://github.com/caarlos0/dotfiles.fish)

This is my latest attempt, using nix.

# What's different

Not much, this is roughly a translation from the latest state of
`dotfiles.fish`, although some parts are still missing (pending me learning
nix-darwin), and others are a bit different, like the way Fish and neovim are set
up.

Other than that, more of the same...

# Setting up

1. [Install nix](https://nixos.org/download.html)
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```
1. Enable community build caches and flakes:
   ```bash
   nix-env -iA cachix -f https://cachix.org/api/v1/install
   cachix use nix-community
   echo "trusted-users = root carlos" | sudo tee -a /etc/nix/nix.conf && sudo pkill nix-daemon
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```
1. [Install home-manager](https://nix-community.github.io/home-manager/index.html#sec-install-standalone)
   ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
   nix-channel --update
   nix-shell '<home-manager>' -A install
   source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
   ```
1. Apply _home-manager_
   ```bash
   home-manager switch --flake ".#carlos@$(hostname)"
   ```
1. Set the default shell
   ```bash
   which fish | sudo tee -a /etc/shells
   chsh -s $(which fish)
   ```
1. Apply _nix-darwin_ (optional)
   ```bash
   nix build "./#darwinConfigurations.$(hostname).system"
   ./result/sw/bin/darwin-rebuild switch --flake .
   ```

This is the whole initial setup, after that, you should be able to log into a
`fish`, after that, you can check the [applying](#Updating) section bellow.

# Updating

To apply updates, simply run:

```bash
task update apply
```

On macOS, you can also apply the _nix-darwin_ stuff:

```bash
task update apply apply_darwin
```

# Clean up

```sh
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
