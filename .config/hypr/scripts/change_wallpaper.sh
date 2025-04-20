#!/bin/bash

# Wait for hyprpaper to start
echo "Waiting for hyprpaper to start..."
while ! pgrep -x "hyprpaper" > /dev/null; do
    sleep 1
done

# Once hyprpaper is running, proceed
echo "hyprpaper is running. Starting wallpaper changer..."

TILE_DIR="$HOME/.wallpapers/tile"
NORMAL_DIR="$HOME/.wallpapers/normal"

MONITOR="eDP-1"

INTERVAL=$((60 * 20)) # 1Hr
while true; do
    # Find a random wallpaper
    WALLPAPER=$(find "$NORMAL_DIR" -type f | shuf -n 1)
    echo "Setting wallpaper: $WALLPAPER"

    # Preload the wallpaper
    hyprctl hyprpaper preload "$WALLPAPER"

    # Set the wallpaper
    hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"

    # Sleep for the interval
    sleep $INTERVAL
done
