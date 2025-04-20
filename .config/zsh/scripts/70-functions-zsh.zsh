#!/usr/bin/env zsh

# Unalias standard commands if they exist
unalias ls 2>/dev/null
unalias ll 2>/dev/null
unalias la 2>/dev/null
unalias lt 2>/dev/null

# Enhanced ls with eza
function ls() {
  eza --icons --color=auto -F "$@"
}
compdef ls=ls

# List with details
function ll() {
  eza -l --icons --git "$@"
}
compdef ll=ls

# List all files
function la() {  
  eza -la --icons --git "$@"
}
compdef la=ls

# Tree view
function lt() {
  eza --icons --tree --color=auto -F ${1:+--level=${1}} "${@:2}"
}
compdef lt=ls

# Show recently modified files
function lr() {
  eza -l --sort=modified --icons --git --reverse "$@"
}
compdef lr=ls

# Extract archives
function extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create and enter directory
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Git related functions
function glog() {
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit "$@"
}

# Find files
function ff() {
  find . -type f -name "*$1*" | sort
}

# Find directories
function fd() {
  find . -type d -name "*$1*" | sort
}

# Switch between projects
function proj() {
  local projdir="$HOME/projects"
  local dir
  
  if [[ ! -d "$projdir" ]]; then
    echo "Project directory doesn't exist: $projdir"
    return 1
  fi
  
  if [[ -z "$1" ]]; then
    # Interactive selection with fzf
    dir=$(find "$projdir" -mindepth 1 -maxdepth 1 -type d | fzf --preview="ls -la {}")
    [[ -n "$dir" ]] && cd "$dir"
  else
    # Direct path
    cd "$projdir/$1" 2>/dev/null || echo "Project not found: $1"
  fi
}

# Toggle theme between light and dark
function toggle-theme() {
  if [[ "$THEME_MODE" == "dark" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    hyprctl keyword general:col.active_border "rgba(ccd0daff)"
    export THEME_MODE="light"
    echo "Theme switched to light mode"
  else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    hyprctl keyword general:col.active_border "rgba(b4befeff)"
    export THEME_MODE="dark"
    echo "Theme switched to dark mode"
  fi
}

# Hyprland window switcher
function hws() {
  local window=$(hyprctl clients -j | jq -r '.[] | "\(.address): \(.class) - \(.title)"' | fzf --prompt="Switch to window: ")
  local addr=$(echo $window | cut -d':' -f1)
  [[ -n "$addr" ]] && hyprctl dispatch focuswindow "address:$addr"
}

# Hyprland workspace switcher
function hywsp() {
  local workspace=$(hyprctl workspaces -j | jq -r '.[] | "\(.id): \(.name) (\(.windows) windows)"' | fzf --prompt="Switch to workspace: ")
  local id=$(echo $workspace | cut -d':' -f1)
  [[ -n "$id" ]] && hyprctl dispatch workspace "$id"
}

# Quick edit config files
function conf() {
  local configs=(
    "zsh:$ZDOTDIR/.zshrc"
    "hypr:$HOME/.config/hypr/hyprland.conf"
    "waybar:$HOME/.config/waybar/config.jsonc"
    "nvim:$HOME/.config/nvim/init.lua"
    "kitty:$HOME/.config/kitty/kitty.conf"
    "alacritty:$HOME/.config/alacritty/alacritty.yml"
    "mako:$HOME/.config/mako/config"
    "neofetch:$HOME/.config/neofetch/config.conf"
  )
  
  local choice
  if [[ -z "$1" ]]; then
    choice=$(printf "%s\n" "${configs[@]}" | cut -d':' -f1 | fzf --prompt="Edit config: ")
  else
    choice="$1"
  fi
  
  if [[ -n "$choice" ]]; then
    local file
    for c in "${configs[@]}"; do
      if [[ "$c" == "$choice":* ]]; then
        file="${c#*:}"
        break
      fi
    done
    
    if [[ -n "$file" ]]; then
      $EDITOR "$file"
    else
      echo "Config not found: $choice"
    fi
  fi
}

# Monitor layout switcher
function monitor() {
  case "$1" in
    single)
      hyprctl keyword monitor "eDP-1,preferred,auto,1"
      hyprctl keyword monitor "DP-1,disable"
      ;;
    dual)
      hyprctl keyword monitor "eDP-1,preferred,auto,1"
      hyprctl keyword monitor "DP-1,preferred,auto,1,mirror,eDP-1"
      ;;
    external)
      hyprctl keyword monitor "eDP-1,disable"
      hyprctl keyword monitor "DP-1,preferred,auto,1"
      ;;
    *)
      echo "Usage: monitor [single|dual|external]"
      ;;
  esac
}

# Clipboard manager with fzf
function clipboard() {
  local selected=$(cliphist list | fzf --prompt="Select from clipboard: " --preview="echo {} | cliphist decode")
  [[ -n "$selected" ]] && echo "$selected" | cliphist decode | wl-copy
}
