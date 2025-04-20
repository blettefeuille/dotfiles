#!/usr/bin/env zsh

# Arch-specific helpers and configurations

# Pacman shortcuts
alias pacup='sudo pacman -Syu'                 # Update system
alias pacin='sudo pacman -S'                   # Install package
alias pacrem='sudo pacman -Rs'                 # Remove package
alias pacsearch='pacman -Ss'                   # Search for package
alias pacclean='sudo pacman -Sc'               # Clean package cache
alias pacinfo='pacman -Qi'                     # Package info
alias paclist='pacman -Qe'                     # List explicitly installed packages
alias pacorphan='pacman -Qtdq'                 # List orphaned packages

# Improved pacman functions
function pacbrowse() {
  local pkg=$(pacman -Slq | fzf --preview 'pacman -Si {}')
  if [[ -n "$pkg" ]]; then
    echo "Installing $pkg..."
    sudo pacman -S "$pkg"
  fi
}

function pacrembrowse() {
  local pkg=$(pacman -Qeq | fzf --preview 'pacman -Qi {}')
  if [[ -n "$pkg" ]]; then
    echo "Removing $pkg..."
    sudo pacman -Rs "$pkg"
  fi
}

# AUR helper (yay/paru) support
if command -v yay &>/dev/null; then
  alias yayup='yay -Syu'
  alias yayin='yay -S'
  alias yaysearch='yay -Ss'
  
  function yaybrowse() {
    local pkg=$(yay -Slq | fzf --preview 'yay -Si {}')
    [[ -n "$pkg" ]] && yay -S "$pkg"
  }
elif command -v paru &>/dev/null; then
  alias paruup='paru -Syu'
  alias paruin='paru -S'
  alias parusearch='paru -Ss'
  
  function parubrowse() {
    local pkg=$(paru -Slq | fzf --preview 'paru -Si {}')
    [[ -n "$pkg" ]] && paru -S "$pkg"
  }
fi

# System management
function syscheck() {
  echo "== System Status =="
  echo "Memory usage:"
  free -h
  echo
  echo "Disk usage:"
  df -h | grep -v tmpfs
  echo
  echo "CPU usage:"
  top -bn1 | head -n 20
  echo
  echo "Failed services:"
  systemctl --failed
  echo
  echo "Journal errors:"
  journalctl -p 3 -b --no-pager | tail -n 10
}

# Find and clean up old or large packages
function paclargest() {
  expac -H M '%m\t%n' | sort -hr | head -n 20
}

function pacoldest() {
  expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | head -n 20
}

# Check for news before upgrading
function arch-news() {
  local url="https://archlinux.org/news/"
  if command -v w3m &>/dev/null; then
    w3m "$url"
  elif command -v lynx &>/dev/null; then
    lynx "$url"
  else
    xdg-open "$url"
  fi
}

# Update before upgrading
function smart-update() {
  # Check for Arch news
  echo "Checking for important Arch news..."
  curl -s "https://www.archlinux.org/feeds/news/" | grep -Po '<title>\K[^<]*(?=</title>)' | head -n 3
  echo
  
  read -q "choice?Do you want to continue with system update? (y/n) "
  echo
  
  if [[ "$choice" == "y" ]]; then
    echo "Updating keyring first..."
    sudo pacman -Sy archlinux-keyring --noconfirm
    
    echo "Updating core system packages..."
    sudo pacman -Su
    
    # Use installed AUR helper
    if command -v paru &>/dev/null; then
      echo "Updating AUR packages with paru..."
      paru -Sua
    elif command -v yay &>/dev/null; then
      echo "Updating AUR packages with yay..."
      yay -Sua
    else
      echo "No AUR helper found. Core system updated."
    fi
    
    echo "Update complete!"
  else
    echo "Update canceled."
  fi
}

# Set up pacman hook listening - useful for knowing when packages are installed/removed
function paclog() {
  sudo journalctl -f | grep -i --line-buffered "pacman\|yay\|paru"
}
