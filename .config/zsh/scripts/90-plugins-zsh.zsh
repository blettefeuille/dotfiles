#!/usr/bin/env zsh

# Plugin installation function
function install_plugin() {
  local repo_url="$1"
  local plugin_name="${repo_url:t}"  # Extract repo name from URL
  local plugin_dir="$ZPLUGINDIR/$plugin_name"
  
  if [[ ! -d $plugin_dir ]]; then
    echo "Installing $plugin_name..."
    git clone --depth 1 "$repo_url" "$plugin_dir"
  fi
}
# Update all plugins
function update_plugins() {
  local plugin_dir
  for plugin_dir in "$ZPLUGINDIR"/*; do
    if [[ -d "$plugin_dir/.git" ]]; then
      echo "Updating $(basename $plugin_dir)..."
      (cd "$plugin_dir" && git pull --ff-only)
    fi
  done
  echo "All plugins updated!"
}

# Lazy-load complex plugins
function lazy_load() {
  local command="$1"
  local plugin_func="$2"
  local plugin_file="$3"
  
  # Create placeholder function
  eval "$command() { 
    unfunction $command
    source $plugin_file
    $plugin_func
    $command \$@
  }"
}

# Install required plugins
install_plugin "https://github.com/sindresorhus/pure"
install_plugin "https://github.com/zsh-users/zsh-autosuggestions"
install_plugin "https://github.com/zsh-users/zsh-syntax-highlighting"
install_plugin "https://github.com/Aloxaf/fzf-tab"
install_plugin "https://github.com/catppuccin/zsh-syntax-highlighting"

# Add custom plugin directories to fpath
fpath=(
  "$ZPLUGINDIR/pure"
  "/usr/share/zsh/site-functions"
  $fpath
)

# Source the plugins (except syntax highlighting, which is loaded last in .zshrc)
source "$ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZPLUGINDIR/fzf-tab/fzf-tab.zsh"
source "$ZPLUGINDIR/catppuccin/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"

# Initialize prompt
autoload -U promptinit
promptinit
prompt pure
