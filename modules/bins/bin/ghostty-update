#!/usr/bin/env bash
set -eo pipefail
cd /tmp
gh release download -R mitchellh/ghostty tip -p 'ghostty-macos-universal.zip' --clobber
rm -rf ~/Applications/Ghostty.app
unzip -d ~/Applications ghostty-macos-universal.zip
rm -f ghostty-macos-universal.zip
