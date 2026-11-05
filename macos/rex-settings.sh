#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: $0 export|import"
  echo "  export  Update rex/settings.plist from this Mac's saved Rex preferences."
  echo "  import  Apply rex/settings.plist. Quit Rex first, then reopen it."
}

if [ "$#" -eq 1 ] && { [ "$1" = --help ] || [ "$1" = -h ]; }; then
  usage
  exit 0
fi
if [ "$#" -ne 1 ] || { [ "$1" != export ] && [ "$1" != import ]; }; then
  usage >&2
  exit 2
fi
if [ "$(uname -s)" != Darwin ]; then
  echo "error: Rex app preferences require macOS" >&2
  exit 1
fi

settings="$(cd "$(dirname "$0")/.." && pwd)/rex/settings.plist"
domain=com.superlogical.rex

case "$1" in
export)
  temp_dir="$(mktemp -d "$TMPDIR/rex-settings.XXXXXX")"
  trap 'rm -f "$temp_dir/current.plist" "$temp_dir/settings.plist"; rmdir "$temp_dir"' EXIT
  defaults export "$domain" "$temp_dir/current.plist"
  plutil -create xml1 "$temp_dir/settings.plist"
  plutil -convert json -o - "$settings" | jq -r 'keys[]' |
    while IFS= read -r key; do
      keypath="${key//./\\.}"
      value="$(plutil -extract "$keypath" xml1 -o - "$temp_dir/current.plist")"
      plutil -insert "$keypath" -xml "$value" "$temp_dir/settings.plist"
    done
  mv "$temp_dir/settings.plist" "$settings"
  echo "Exported Rex preferences to $settings"
  ;;
import)
  if pgrep -x Rex >/dev/null; then
    echo "error: Quit Rex before importing preferences, then reopen it" >&2
    exit 1
  fi
  plutil -lint "$settings"
  defaults import "$domain" "$settings"
  echo "Imported Rex preferences. Reopen Rex to load them."
  ;;
esac
