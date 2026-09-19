#!/usr/bin/env bash
# Pull MrKraken/StarStrings' player pack into StarStrings/ and replay our meme
# overrides (modified_global_starstrings.ini) on top. Run from repo root.
set -euo pipefail

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git clone -q --depth 1 https://github.com/MrKraken/StarStrings.git "$tmp/ss"

out=StarStrings/data/Localization/english
mkdir -p "$out"
cp "$tmp/ss/src/For_Players/USER.cfg" StarStrings/user.cfg

# Same key=value replay as merge-ini-*.ps1. Keeps each line's CRLF.
awk '
  NR == FNR {
    sub(/\r$/, ""); sub(/^\xef\xbb\xbf/, "")
    i = index($0, "="); if (i) r[substr($0, 1, i - 1)] = substr($0, i + 1)
    next
  }
  {
    i = index($0, "="); k = substr($0, 1, i - 1)
    if (i && (k in r)) { cr = /\r$/ ? "\r" : ""; print k "=" r[k] cr } else print
  }
' merge-process/modified_global_starstrings.ini \
  "$tmp/ss/src/For_Players/Data/Localization/english/global.ini" > "$out/global.ini"
