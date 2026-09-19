#!/usr/bin/env bash
# Replay merge-process/meme-overrides.ini (our meme renames) over every meme pack's
# shipped global.ini, in place. Same key=value replay as merge-ini-*.ps1. Keeps CRLF.
# SmartCitizen is left out on purpose. Run from repo root.
set -euo pipefail

for pack in ScCompLangPack ScCompLangPackRemix2 StarStrings; do
  f=$pack/data/Localization/english/global.ini
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
  ' merge-process/meme-overrides.ini "$f" > "$f.tmp"
  mv "$f.tmp" "$f"
done
