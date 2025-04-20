#!/usr/bin/env zsh
# File: 00-core-zsh.zsh

# Central configuration variables
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# Theme configuration
export THEME_MODE="dark"  # or "light"
export CATPPUCCIN_BLUE="#89b4fa"
export CATPPUCCIN_GREEN="#a6e3a1" 
export CATPPUCCIN_MAUVE="#cba6f7"
export CATPPUCCIN_RED="#f38ba8"
export CATPPUCCIN_PEACH="#fab387"

# Define directory locations
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export ZCACHEDIR="${ZCACHEDIR:-$HOME/.cache/zsh}"
export ZHISTDIR="${ZHISTDIR:-$HOME/.local/share/zsh}"
export ZPLUGINDIR="${ZPLUGINDIR:-$ZDOTDIR/plugins}"

# Create necessary directories
mkdir -p "$ZCACHEDIR" "$ZHISTDIR" "$ZPLUGINDIR"

# Function to detect system type
function get_os() {
  case "$(uname -s)" in
    Linux*)  
      if [ -f /etc/arch-release ]; then
        echo "arch"
      elif [ -f /etc/debian_version ]; then
        echo "debian" 
      else
        echo "linux"
      fi
      ;;
    Darwin*) echo "mac";;
    *)       echo "unknown";;
  esac
}

# Function to detect desktop environment
function get_desktop() {
  if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] || [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    echo "hyprland"
  elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    echo "kde"
  elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    echo "gnome"
  else
    echo "unknown"
  fi
}

# Export system information
export ZSH_SYSTEM="$(get_os)"
export ZSH_DESKTOP="$(get_desktop)"

# Terminal capabilities
export TERM_ITALICS=$(tput sitm)
export TERM_BOLD=$(tput bold)
export TERM_RESET=$(tput sgr0)

# Initialize profiling if requested
if [[ "$ZSH_PROFILE" == "true" ]]; then
  zmodload zsh/zprof
fi
