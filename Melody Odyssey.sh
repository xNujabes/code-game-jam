#!/bin/sh
echo -ne '\033c\033]0;Code Game Jam\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Melody Odyssey.x86_64" "$@"
