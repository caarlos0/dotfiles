#!/bin/bash
set -euo pipefail

echo "Updating Homebrew..."
brew update
brew upgrade
brew cleanup

echo "Updating Brewfile..."
rm Brewfile && brew bundle dump

echo "Updating Neovim..."
nvim --headless +"lua vim.pack.update()" +qa &>/dev/null
