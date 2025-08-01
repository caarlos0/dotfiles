#!/bin/bash
set -euo pipefail

echo "Updating Brewfile..."
rm Brewfile && brew bundle dump

echo "Updating Neovim..."
nvim --headless "lua vim.pack.update()" +qa &>/dev/null

echo "Updating tmux.."
~/.config/tmux/plugins/tpm/bin/update_plugins all
