#!/bin/bash

CONFIG="$HOME/.config/hypr/bindings.conf"
OUTPUT="$HOME/.config/hypr/keybinds.txt"

declare -A varmap

# Catppuccin Mocha colors
MOD_COLOR="#b4befe"       # Lavender
KEY_COLOR="#cba6f7"       # Mauve
ACTION_COLOR="#94e2d5"    # Teal
DESC_COLOR="#a6adc8"      # Subtext

# Parse variable definitions like $mainMod = SUPER
while IFS='=' read -r var val; do
  [[ $var =~ ^\s*\$ ]] || continue
  key=$(echo "$var" | tr -d ' $')
  value=$(echo "$val" | xargs)
  varmap["$key"]="$value"
done < "$CONFIG"

# Clear output file
> "$OUTPUT"

prev_comment=""

# Extract lines and process
rg '^(\s*#.*|bind\s*=)' "$CONFIG" | while IFS= read -r line; do
  if [[ "$line" =~ ^\s*# ]]; then
    prev_comment=$(echo "$line" | sed 's/^\s*#\s*//')
  elif [[ "$line" =~ bind ]]; then
    binding=$(echo "$line" | sed -E 's/^\s*bind\s*=\s*//')

    # Replace Hyprland variables like $mainMod
    for var in "${!varmap[@]}"; do
      binding="${binding//\$$var/${varmap[$var]}}"
    done

    IFS=',' read -r mod key action command <<< "$binding"

    mod=${mod:-"?"}
    key=${key:-"?"}
    action=${action:-"?"}
    command=${command:-""}
    desc=${prev_comment:-"(no description)"}

    # Output with Pango markup
    printf "<span foreground='%s'><b>%-10s</b></span>  " "$MOD_COLOR" "$mod" >> "$OUTPUT"
    printf "<span foreground='%s'>%-6s</span>  " "$KEY_COLOR" "$key" >> "$OUTPUT"
    printf "<span foreground='%s'>%-18s</span>  " "$ACTION_COLOR" "$action $command" >> "$OUTPUT"
    printf "<span foreground='%s'><i>%s</i></span>\n" "$DESC_COLOR" "$desc" >> "$OUTPUT"

    prev_comment=""
  fi
done

