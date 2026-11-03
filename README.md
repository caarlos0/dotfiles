# caarlos0/dotfiles

This is my latest dotfiles generation.

I've been experimenting with many different tools to manage them properly, from
Ansible to shell scripts, and never liked any of them that much, to be honest.

You can see the history on these repositories:

- [dotfiles.zsh](https://github.com/caarlos0/dotfiles.zsh)
- [dotfiles.fish](https://github.com/caarlos0/dotfiles.fish)

Then, I tried nix, which seemed fine, but also overkill for my case.
In the end, what I really wanted was just a simple shell script, which is this
version here!

## Applying

```bash
./setup

# And maybe:
./macos/set-defaults.sh
```

Machine-specific bits (`Brewfile.<host>`, `hammerspoon/apps.<host>.lua`) are
picked by `hostname -s`: `darkmatter` is personal, `quasar` is work.

Copilot settings live in [`copilot/config.ini`](copilot/config.ini), one
`key=value` per line. Values are literal; repeat keys for list settings.
`./setup` applies only settings that do not already match; runtime paths stay
in `setup`.

Copilot agents and skills are symlinked individually into `~/.copilot`. Setup
leaves existing files and directories alone and configures read-write sandbox
access to this repository. Remove old copies of repo-managed entries once
before running setup.

Rex Beta is the preferred terminal for the Hyper+J shortcut and Dock. Install
it separately on each Mac. In Rex settings, import
`~/.config/rex/themes/Catppuccin Mocha Black` under Themes, then choose
Berkeley Mono at 13 pt under Terminal. Rex stores these settings in the app;
`./setup` links the theme file but does not import it or set the font.

## Releasing

```bash
task release
```

## Updating

```bash
task update
```

Run `task nvim` to update Neovim plugins, install missing configured Tree-sitter
parsers, and update installed parsers. Neither startup nor `./setup` updates
plugins or installs parsers.

Inside Neovim, these operations are also available separately:
`:lua vim.pack.update()`, `:TSInstallConfigured`, and `:TSUpdate`.
