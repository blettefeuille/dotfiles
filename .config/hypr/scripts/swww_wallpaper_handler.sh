#!/bin/bash

WALLPAPER_DIR="$HOME/.wallpapers/normal"

# Init swww if needed
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww init
    sleep 0.5
fi

while true; do
    RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)
    swww img "$RANDOM_WALL" --transition-type grow --transition-fps 60 --transition-duration 2
    sleep 600  # 10 minutes
done

