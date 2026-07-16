#!/bin/bash

CONFIG="$HOME/.config/fastfetch/config.jsonc"
DIR="$HOME/.config/fastfetch"

ESCOLHA=$(find "$DIR" -maxdepth 1 -name "*.txt" -printf "%f\n" | wofi --dmenu -p "ASCII")

[ -z "$ESCOLHA" ] && exit 0

sed -i "s|\"source\": \".*\"|\"source\": \"$DIR/$ESCOLHA\"|" "$CONFIG"

fastfetch
