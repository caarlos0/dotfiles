#!/bin/bash
set -euo pipefail

echo "Updating Homebrew..."
brew update
brew upgrade
brew cleanup

echo "Updating Brewfile..."
rm Brewfile && brew bundle dump --no-go

echo "Updating Neovim..."
plugins=$(jq '.plugins | keys[]' ./nvim/nvim-pack-lock.json | tr '\n' ', ')
nvim --headless +"lua vim.pack.update({${plugins}},{force = true})" +qa &>/dev/null

if [ "$(git symbolic-ref --short HEAD)" = "main" ]; then
  echo "Commiting changes..."
  git add Brewfile
  git commit -m 'chore(darwin): update Brewfile'
  git add ./nvim/nvim-pack-lock.json
  git commit -m 'chore(nvim): update lockfile'
fi
