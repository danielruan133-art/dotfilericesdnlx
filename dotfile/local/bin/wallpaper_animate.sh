#!/bin/bash

VIDEO=$(find /home/dnlx/wallpaper_animate -type f | sed 's|/home/dnlx/wallpaper_animate/||' | wofi --dmenu --prompt "Wallpaper Animado")

[ -z "$VIDEO" ] && exit 0

VIDEO="/home/dnlx/wallpaper_animate/$VIDEO"

pkill swaybg
pkill mpvpaper

mpvpaper '*' -o "--loop-file=inf --no-audio" "$VIDEO" &
