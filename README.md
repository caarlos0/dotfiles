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

Run `./macos/set-dock.sh` to apply `macos/dock.<host>.txt` and refresh the Dock
without changing other macOS settings. Both lists use Rex as the terminal.

Copilot settings live in [`copilot/config.ini`](copilot/config.ini), one
`key=value` per line. Values are literal; repeat keys for list settings.
`./setup` applies only settings that do not already match; runtime paths stay
in `setup`.

Copilot agents and skills are symlinked individually into `~/.copilot`. Setup
leaves existing files and directories alone and configures read-write sandbox
access to this repository. Remove old copies of repo-managed entries once
before running setup.

Use `copilot --agent coordinator` for general coordination,
`copilot --agent implementation-coordinator` for implementation, or
`copilot --agent review-coordinator` for code reviews. All three preload the
shared `coordinator` skill for Rex workers, durable handoffs, and cleanup.
The skill cannot be invoked independently.

Rex Beta is the only terminal, used by the Hyper+J shortcut and Dock. Install
it separately on each Mac. `./setup` links its Lua config and theme files.

Rex has no full-settings export command. Reuse its saved macOS preferences:

1. Run `./macos/rex-settings.sh export` to update `rex/settings.plist`.
2. On the other Mac, quit Rex and run `./macos/rex-settings.sh import`.
3. Reopen Rex and import `~/.config/rex/themes/Catppuccin Mocha Black` in
   Settings > Themes. Enable Remote Control in Settings > Server > Client Info
   for the project picker and CLI client actions.

The plist contains only selected appearance and terminal preferences, including
Berkeley Mono at 12 pt. Export uses its keys as the allowlist. It excludes custom
theme IDs, server addresses, access grants, and session/window state. Import
preserves unrelated preferences. The theme is imported separately because Rex
assigns custom themes machine-local IDs.

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
