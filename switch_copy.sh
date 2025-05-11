#!/usr/bin/env bash

BASE_SRC=$(find /run/user/$(id -u)/gvfs/ -maxdepth 1 -name "mtp:host=Nintendo_Nintendo_Switch_*" | head -n 1)/Album
BASE_DST=~/switch_screenshots

find "$BASE_SRC" -type f | while read file; do
  rel_path="${file#$BASE_SRC/}"
  dest_dir="$BASE_DST/$(dirname "$rel_path")"
  mkdir -p "$dest_dir"

  if [ -f "$dest_dir/$(basename "$file")" ]; then
    echo "$(basename "$file") exist"
  else
    echo "now coping $(basename "$file")"
    gio copy "$file" "$dest_dir/"
  fi
done

echo "Copy complete!"
