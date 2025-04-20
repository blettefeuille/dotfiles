#!/usr/bin/env zsh

# Performance optimizations

# Compile zcompdump if modified
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit -d "$ZCACHEDIR/.zcompdump"
  # Compile the completion dump to increase startup speed
  { zcompile "$ZCACHEDIR/.zcompdump" } &!
else
  compinit -C -d "$ZCACHEDIR/.zcompdump"
fi

# Compile zsh files for faster loading
function zcompile-many() {
  local file
  for file in "$@"; do
    if [[ -f "$file" && (! -f "${file}.zwc" || "$file" -nt "${file}.zwc") ]]; then
      zcompile "$file"
      echo "Compiled $file"
    fi
  done
}

# Compile config files if needed
function optimize-zsh-startup() {
  echo "Optimizing ZSH startup performance..."
  
  # Compile all zsh scripts
  zcompile-many "$ZDOTDIR"/.zshrc
  zcompile-many "$ZDOTDIR"/scripts/*.zsh
  
  # Compile plugin files
  for plugin_dir in "$ZPLUGINDIR"/*; do
    if [[ -d "$plugin_dir" ]]; then
      zcompile-many "$plugin_dir"/*.zsh
    fi
  done
  
  echo "Optimization complete!"
}

# Startup command - run less frequently used commands async
function async-init() {
  {
    # Update plugin status check
    last_update=$(stat -c %Y "$ZPLUGINDIR/last_update" 2>/dev/null || echo 0)
    now=$(date +%s)
    if (( now - last_update > 604800 )); then  # One week
      echo "Plugins haven't been updated in over a week. Run 'update_plugins' to update."
      touch "$ZPLUGINDIR/last_update"
    fi
  } &!
}

# Run async initialization
async-init
