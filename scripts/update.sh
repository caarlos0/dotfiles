#!/bin/bash
set -euo pipefail

host="$(hostname -s)"
if [ ! -f Brewfile."$host" ]; then
  echo "No Brewfile.$host: run this from the repository root, on a known machine."
  exit 1
fi

echo "Updating Homebrew..."
brew update
brew upgrade --yes
brew autoremove
brew cleanup --scrub --prune 0

echo "Updating Brewfile.$host..."
brew bundle dump --file Brewfile."$host" --no-go --no-uv --no-cargo --no-npm --force

echo "Updating Neovim plugins..."
nvim --headless +"lua vim.pack.update(nil, { force = true })" +qa &>/dev/null

if [ "$(git symbolic-ref --short HEAD)" = "main" ]; then
  echo "Commiting changes..."
  git add Brewfile."$host"
  git diff --cached --quiet || git commit -m "chore(darwin): update Brewfile.$host"
  git add ./nvim/nvim-pack-lock.json
  git diff --cached --quiet || git commit -m 'chore(nvim): update lockfile'
fi
