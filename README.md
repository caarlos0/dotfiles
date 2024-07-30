# caarlos0/dotfiles

This is my latest dotfiles generation.

I've been experimenting with many different tools to manage them properly, from
Ansible to shell scripts, and never liked any of them that much, to be honest.

You can see the history on these repositories:

- [dotfiles.zsh](https://github.com/caarlos0/dotfiles.zsh)
- [dotfiles.fish](https://github.com/caarlos0/dotfiles.fish)

This is my most recent attempt, using nix.

It contains **home-manager**, **nixOS** and **nix-darwin** configuration
for several machines and VMs I use.

# First run

```bash
sh <(curl -L https://nixos.org/nix/install)
echo "experimental-features = nix-command flakes">~/.config/nix/nix.conf
```

On macOS, install homebrew too:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Also make sure the terminal being used has full disk access, otherwise you might
get errors like `Could not write domain`.

# Updating

To apply updates, simply run:

```bash
nix develop -c dot-apply

# pull, update flake, clean old, apply
nix develop -c dot-sync
```

# Clean up

```sh
nix develop -c dot-clean
```

# Create release

To create a release, run:

```bash
nix develop -c dot-release
```

# Post first run

## Fish as the default shell

```sh
which fish | sudo tee -a /etc/shells
chsh -s $(which fish)
```

## Keyboard layouts

Add the US layout so input doesn't wait after opening quotes and such.
