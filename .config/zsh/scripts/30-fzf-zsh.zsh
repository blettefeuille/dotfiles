#!/usr/bin/env zsh

# Check if FZF is installed
if [[ ! -d ~/.fzf ]] && command -v fzf >/dev/null 2>&1; then
  # FZF base configuration - Catppuccin Mocha theme
  export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --inline-info
  --border=none
  --border-label=' ☉__☉  '
  --info='right'
  --pointer='▶'
  --marker='✓'
  --prompt='❯ '
  --preview-window='right:50%:wrap:border-double'
  --color=fg:#cdd6f4,hl:#f38ba8
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8
  --color=info:#74c7ec,prompt:#cba6f7,pointer:#f9e2af
  --color=marker:#f2cdcd,spinner:#a6e3a1,header:#b4befe
  --color=border:#b4befe,label:#f5c2e7
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-d:preview-page-down'
  --bind='ctrl-u:preview-page-up'
  --bind='ctrl-y:execute-silent(echo {} | wl-copy)'
  --bind='ctrl-space:toggle+up'
  --bind='alt-j:preview-down'
  --bind='alt-k:preview-up'
  --bind='alt-v:toggle-all'
  --bind='tab:down,shift-tab:up'
  --bind='ctrl-f:half-page-down'
  --bind='ctrl-b:half-page-up'
  --bind='ctrl-g:top'
  --bind='ctrl-q:abort'
  --bind='alt-e:execute(echo {} | xargs -r $EDITOR)'
  "

  # Set up image preview script
  PREVIEW_SCRIPT="$XDG_CONFIG_HOME/fzf/image_preview.sh"

  # Create image preview script if it doesn't exist
  if [[ ! -f "$PREVIEW_SCRIPT" ]]; then
    mkdir -p "$(dirname "$PREVIEW_SCRIPT")"
    cat >"$PREVIEW_SCRIPT" <<'EOF'
#!/usr/bin/env bash

file="$1"
width="${2:-$(tput cols)}"
height="${3:-$(tput lines)}"
maxln=80

# File type detection
mime=$(file -bL --mime-type "$file")
category=${mime%%/*}
kind=${mime##*/}

# Handle file by type
case "$category" in
    image)
        # Try to use terminal image viewers
        if command -v kitten &> /dev/null && [[ "$TERM" == "xterm-kitty" ]]; then
            kitten icat --clear --transfer-mode=file --place="${width}x$((height/2))@0x0" "$file"
        elif command -v chafa &> /dev/null; then
            chafa -s "${width}x$((height/2))" "$file"
        elif command -v catimg &> /dev/null; then
            catimg -w "$width" -r "$((height/2))" "$file"
        else
            echo "Image preview not available (install kitty, chafa, or catimg)"
            echo "File: $file"
            echo "Type: $mime"
        fi
        ;;
    text)
        # Syntax highlight for text
        if command -v bat &> /dev/null; then
            bat --style=numbers,changes --color=always --line-range :$maxln "$file"
        else
            head -n $maxln "$file"
        fi
        ;;
    *)
        # Default handling
        echo "File: $file"
        echo "Type: $mime"
        file -b "$file"
        ;;
esac
EOF
    chmod +x "$PREVIEW_SCRIPT"
  fi

  # Configure FZF default command to use ripgrep
  export FZF_DEFAULT_COMMAND='
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$git_root" ]; then
      rg --files --hidden --follow --glob "!.git/*" "$git_root" | while read -r file; do
        realpath --relative-to="." "$file"
      done
    else
      rg --files --hidden --follow --glob "!.git/*"
    fi
  '

  # CTRL-T - File search
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS="
  --preview='$PREVIEW_SCRIPT {}'
  --preview-window='right:50%:wrap:border-double'
  --border-label=' Files '
  --prompt='Files ❯ '
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-o:execute(xdg-open {} &>/dev/null &)'
  "

  # ALT-C - Directory navigation
  export FZF_ALT_C_COMMAND="eza --color=always --all --only-dirs --sort=modified --icons"
  export FZF_ALT_C_OPTS="
  --ansi
  --preview 'eza --tree --level=2 --color=always --icons -- {}'
  --preview-window right:50%:wrap:border-rounded
  --border-label=' Directories '
  --prompt='Dirs ❯ '
  --bind 'ctrl-/:toggle-preview'
  "

  # CTRL-R - History search
  export FZF_CTRL_R_OPTS="
  --no-preview
  --border-label=' History '
  --prompt='Shell Hist ❯ '
  "

  # Source FZF key bindings and completion
  local fzf_scripts=(
    "/usr/share/fzf/key-bindings.zsh"
    "/usr/share/fzf/completion.zsh"
  )

  for script in "${fzf_scripts[@]}"; do
    if [[ -f "$script" ]]; then
      echo "$script"
      source "$script"
    fi
  done

  # Fallback - create our own FZF scripts if not found
  if ! declare -f fzf-file-widget >/dev/null; then
    # Create key-bindings.zsh
    mkdir -p "$ZDOTDIR/scripts"
    curl -s https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh >"$ZDOTDIR/scripts/key-bindings.zsh"
    source "$ZDOTDIR/scripts/key-bindings.zsh"

    # Create completion.zsh
    curl -s https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh >"$ZDOTDIR/scripts/completion.zsh"
    source "$ZDOTDIR/scripts/completion.zsh"
  fi

fi

# Initialize zoxide (modern cd command)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi
