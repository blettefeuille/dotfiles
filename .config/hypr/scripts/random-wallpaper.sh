#!/bin/bash

# Set the wallpaper directory
WALLPAPER_DIR="$HOME/.wallpapers/normal"

# Get a random wallpaper from the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Create a temporary hyprpaper config file
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"

# Clear the previous config
echo "preload = $WALLPAPER" > "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"

hyprpaper
