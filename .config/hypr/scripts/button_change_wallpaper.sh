#!/bin/bash

WALLPAPER_DIR="$HOME/.wallpapers/normal"
XY_TO_PERCENT_SCRIPT="$HOME/.config/hypr/scripts/xy_to_percentage.sh"

# Get cursor position
read CURSOR_X CURSOR_Y <<< $(hyprctl cursorpos | tr -d ',')

# Convert cursor position to percentage using the helper script
read POS_X POS_Y <<< $("$XY_TO_PERCENT_SCRIPT" "$CURSOR_X" "$CURSOR_Y")
POS_Y=$(awk -v py="$POS_Y" 'BEGIN {print 1 - py}')

if [ $? -ne 0 ]; then
    echo "Failed to determine cursor-relative position"
    exit 1
fi

# Start swww if not already running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww init
    sleep 0.5
fi

# Pick a random wallpaper
RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

# Set the wallpaper with a smooth transition from the click location
swww img "$RANDOM_WALL" \
    --transition-type grow \
    --transition-fps 60 \
    --transition-duration 2 \
    --transition-pos "$POS_X,$POS_Y"
