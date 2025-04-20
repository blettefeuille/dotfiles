#!/usr/bin/env zsh

# Hyprland-specific environment variables
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

# Wayland-specific variables
export MOZ_ENABLE_WAYLAND=1
export CLUTTER_BACKEND=wayland
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export XCURSOR_SIZE=24

# Screen recording variables
export WLR_RENDERER=vulkan
export LIBVA_DRIVER_NAME=nvidia  # Change to your graphics driver: nvidia, radeon, intel-media-driver, etc.

# Screensharing
export PIPEWIRE_RUNTIME_DIR=/run/user/$(id -u)/pipewire

# Clipboard history (if installed)
if command -v wl-paste >/dev/null 2>&1 && command -v cliphist >/dev/null 2>&1; then
  # Ensure clipboard daemon is running
  if ! pgrep -x wl-paste >/dev/null; then
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
  fi
fi

# Hyprland-specific keybindings
if [[ "$XDG_SESSION_TYPE" == "wayland" && "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
  # Keybinding for screenshots
  bindkey -s '^[s' 'grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png\n'
  
  # Keybinding for clipboard capture
  bindkey -s '^[c' 'grim -g "$(slurp)" - | wl-copy\n'
fi

# Hyprland-specific functions

# Switch between workspaces
function workspace() {
  local workspaceNum="$1"
  if [[ -z "$workspaceNum" ]]; then
    workspaceNum=$(seq 1 10 | fzf --prompt="Workspace: ")
  fi
  
  if [[ -n "$workspaceNum" ]]; then
    hyprctl dispatch workspace "$workspaceNum"
  fi
}

# Quick window switcher for Hyprland
function window() {
  windows=$(hyprctl clients -j | jq -r '.[] | "\(.address): \(.class) - \(.title)"')
  selection=$(echo "$windows" | fzf --prompt="Switch to: ")
  
  if [[ -n "$selection" ]]; then
    address=$(echo "$selection" | cut -d':' -f1)
    hyprctl dispatch focuswindow "address:$address"
  fi
}

# Screenshot utility
function screenshot() {
  local mode="$1"
  local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  local dir="$HOME/Pictures/Screenshots"
  mkdir -p "$dir"
  
  case "$mode" in
    area)
      grim -g "$(slurp)" "$dir/$timestamp.png"
      ;;
    window)
      active_window=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
      grim -g "$active_window" "$dir/$timestamp.png"
      ;;
    screen)
      active_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
      grim -o "$active_monitor" "$dir/$timestamp.png"
      ;;
    clipboard)
      grim -g "$(slurp)" - | wl-copy
      ;;
    *)
      echo "Usage: screenshot [area|window|screen|clipboard]"
      return 1
      ;;
  esac
  
  if [[ "$mode" != "clipboard" ]]; then
    echo "Screenshot saved to $dir/$timestamp.png"
    # Notify with preview if available
    if command -v notify-send &>/dev/null; then
      notify-send -i "$dir/$timestamp.png" "Screenshot" "Saved to $dir/$timestamp.png"
    fi
  else
    echo "Screenshot copied to clipboard"
    # Notify
    if command -v notify-send &>/dev/null; then
      notify-send "Screenshot" "Copied to clipboard"
    fi
  fi
}

# Toggle night light/blue light filter
function nightlight() {
  if pgrep -x "wlsunset" > /dev/null; then
    killall wlsunset
    echo "Night light disabled"
  else
    wlsunset -t 4500 -T 6500 &
    echo "Night light enabled"
  fi
}

# Control Hyprland opacity
function opacity() {
  local level="$1"
  
  if [[ -z "$level" ]]; then
    echo "Usage: opacity <0.0-1.0>"
    return 1
  fi
  
  hyprctl keyword decoration:active_opacity "$level"
  hyprctl keyword decoration:inactive_opacity "$level"
  echo "Window opacity set to $level"
}

# Generate a color picker
function colorpicker() {
  hyprpicker -a -f hex | wl-copy
  echo "Color copied to clipboard"
}
