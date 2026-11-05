#!/bin/sh
set -eu

if [ "$(uname -s)" != "Darwin" ]; then
  exit 0
fi

host="$(hostname -s)"
dock_list="$(dirname "$0")/dock.$host.txt"
if [ ! -f "$dock_list" ]; then
  echo "No dock.$host.txt, leaving Dock apps alone"
  exit 0
fi

echo "Setting Dock apps from dock.$host.txt"
defaults write com.apple.dock persistent-apps -array
while IFS= read -r app || [ -n "$app" ]; do
  case "$app" in '' | '#'*) continue ;; esac
  if [ ! -e "$app" ]; then
    echo "  Skipping $app, not installed"
    continue
  fi
  app="$(cd "$app" && pwd -P)"
  defaults write com.apple.dock persistent-apps -array-add \
    "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
done <"$dock_list"

echo "Keeping only Downloads in the Dock's folder section"
defaults write com.apple.dock persistent-others -array \
  "<dict><key>tile-type</key><string>directory-tile</string><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$HOME/Downloads/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

for pid in $(pgrep -x Dock); do
  kill "$pid"
done
