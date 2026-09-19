#!/usr/bin/env bash
# Pull MrKraken/StarStrings' player pack into StarStrings/, then reapply our meme
# overrides. Run from repo root.
set -euo pipefail

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git clone -q --depth 1 https://github.com/MrKraken/StarStrings.git "$tmp/ss"

mkdir -p StarStrings/data/Localization/english
cp "$tmp/ss/src/For_Players/USER.cfg" StarStrings/user.cfg
cp "$tmp/ss/src/For_Players/Data/Localization/english/global.ini" StarStrings/data/Localization/english/global.ini
bash merge-process/apply-overrides.sh
