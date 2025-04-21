#!/bin/bash

KEYBINDS_TXT="$HOME/.config/hypr/keybinds.txt"
EXTRACT_SCRIPT="$HOME/.config/hypr/extract_hyprland_keybindings.sh"
WOFI_CONFIG="$HOME/.config/wofi/keybinds/config"
WOFI_STYLE="$HOME/.config/wofi/keybinds/keybinds.css"

# Generate keybinds.txt if it doesn't exist or is empty
if [[ ! -s "$KEYBINDS_TXT" ]]; then
    echo "Generating keybinds list..."
    if [[ -x "$EXTRACT_SCRIPT" ]]; then
        "$EXTRACT_SCRIPT"
    else
        echo "Error: extract_keybinds.sh not found or not executable."
        exit 1
    fi
fi

# Show keybindings with wofi
wofi --dmenu \
     --allow-markup \
     --conf "$WOFI_CONFIG" \
     --style "$WOFI_STYLE" \
     --prompt "Keybindings" < "$KEYBINDS_TXT"

