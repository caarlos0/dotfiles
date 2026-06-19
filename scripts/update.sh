#!/bin/bash
set -euo pipefail

echo "Updating Homebrew..."
brew update
brew upgrade --yes
brew autoremove
brew cleanup

echo "Updating Brewfile..."
brew bundle dump --no-go --no-uv --no-cargo --no-npm --force

echo "Updating Neovim plugins..."
nvim --headless +"lua vim.pack.update(nil, { force = true })" +qa &>/dev/null

if [ "$(git symbolic-ref --short HEAD)" = "main" ]; then
  echo "Commiting changes..."
  git add Brewfile
  git diff --cached --quiet || git commit -m 'chore(darwin): update Brewfile'
  git add ./nvim/nvim-pack-lock.json
  git diff --cached --quiet || git commit -m 'chore(nvim): update lockfile'
fi
