#!/usr/bin/env zsh

# Initialize completion system

# Completion options
setopt COMPLETE_IN_WORD     # Complete from both ends of a word
setopt ALWAYS_TO_END        # Move cursor to the end of a completed word
setopt AUTO_MENU            # Show completion menu on a successive tab press
setopt AUTO_LIST            # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash
setopt EXTENDED_GLOB        # Needed for file modification glob modifiers with compinit

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Colored completion based on LS_COLORS
zstyle ':completion:*' group-name ''                      # Group matches by type
zstyle ':completion:*:descriptions' format "%F{$CATPPUCCIN_MAUVE}-- %d --%f"
zstyle ':completion:*:messages' format "%F{$CATPPUCCIN_GREEN}-- %d --%f"
zstyle ':completion:*:warnings' format "%F{$CATPPUCCIN_RED}-- no matches found --%f"

# Cache completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZCACHEDIR/zcompcache"

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios named netdump news \
  nfsnobody nobody nscd ntp nut nx openvpn operator pcap postfix \
  postgres privoxy pulse pvm quagga radvd rpc rpcuser rpm shutdown \
  squid sshd sync uucp vcsa xfs

# Use tmux popup (if available)
# Base configuration (tmux popup and padding)
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-pad 30 0

# Apply your FZF styling and keybinds
local fzf_flags=(
    --height=40%
    --layout=reverse
    --inline-info
    --border=none
    --border-label=' ☉__☉  '
    --info='right'
    --pointer='▶'
    --marker='✓'
    --prompt='❯ '
    --color='fg:#cdd6f4,hl:#f38ba8'
    --color='fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8'
    --color='info:#74c7ec,prompt:#cba6f7,pointer:#f9e2af'
    --color='marker:#f2cdcd,spinner:#a6e3a1,header:#b4befe'
    --color='border:#b4befe,label:#f5c2e7'
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
    --bind='alt-e:execute(echo {} | xargs -r nvim)'
)
zstyle ':fzf-tab:*' fzf-flags ${fzf_flags}

# Disable preview for most commands
zstyle ':fzf-tab:complete:-command-:*' fzf-preview ''
zstyle ':fzf-tab:complete:-command-:*' fzf-flags --preview-window=none

# File/directory previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand):*' \
    fzf-preview 'echo ${(P)word}'

# Use single selection mode for rm, kill for safety
zstyle ':fzf-tab:complete:rm:*' single-group default
zstyle ':fzf-tab:complete:kill:*' single-group default


# Special handling for ps and kill commands
zstyle ':fzf-tab:complete:ps:*' fzf-preview 'ps -p ${word} -o pid,user,command'
zstyle ':fzf-tab:complete:kill:*' fzf-preview 'ps -p ${word} -o pid,user,command,state'
zstyle ':fzf-tab:complete:killall:*' fzf-preview 'pgrep -fl ${word} | head -20'

# Podman completions (minimal preview)
zstyle ':fzf-tab:complete:podman-inspect:argument-rest' fzf-preview 'podman inspect $word | jq'

# Man page preview
zstyle ':fzf-tab:complete:man:*' fzf-preview 'man $word | bat --color=always -plman'

# Disable preview for these command groups
zstyle ':fzf-tab:complete:git:*' fzf-preview ''
zstyle ':fzf-tab:complete:podman:*' fzf-preview ''
zstyle ':fzf-tab:complete:podman-(run|images):argument-rest' fzf-preview ''
zstyle ':fzf-tab:complete:podman-container:argument-rest' fzf-preview ''

# ----- Enhanced Git Completion -----

# Add git completion only when explicitly requested or when not disabled in your config
if [[ "$ENABLE_GIT_PREVIEW" == "true" ]]; then
  zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
    'git diff --color=always $word | grep -v "^-" | bat --style=numbers --color=always'
  zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
    'git log --color=always $word'
  zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
    'git help $word | bat --plain --language=man --color=always'
fi

# Systemd service status preview
zstyle ':fzf-tab:complete:systemctl-(status|stop|restart|start):*' fzf-preview '
  SYSTEMD_COLORS=1 systemctl status $word'

# Font preview with fontpreview (if installed)
zstyle ':fzf-tab:complete:*:*.ttf' fzf-preview '
  if command -v fontpreview &>/dev/null; then
    fontpreview -s "The quick brown fox jumps over the lazy dog" $realpath | convert - -resize 400x400 sixel:-
  else
    echo "Font file: $realpath"
    echo "Install fontpreview for previews"
  fi'

# Hyprland configuration file preview
zstyle ':fzf-tab:complete:*:*hypr*conf*' fzf-preview '
  [[ -f $realpath ]] && bat --color=always --style=numbers --language=bash $realpath || echo "Not a file"'

# Preview Hyprland-related commands
zstyle ':fzf-tab:complete:hyprctl:*' fzf-preview '
  if [[ $group == monitors ]]; then
    hyprctl monitors
  elif [[ $group == workspaces ]]; then
    hyprctl workspaces
  elif [[ $group == clients ]]; then
    hyprctl clients
  else
    echo "Hyprland command: $word"
  fi'

# Pacman and AUR helper enhancements
zstyle ':fzf-tab:complete:pacman:*' fzf-preview 'pacman -Si $word 2>/dev/null || pacman -Qi $word 2>/dev/null || echo "Package not found"'

# Support for popular AUR helpers
if command -v paru &>/dev/null; then
  zstyle ':fzf-tab:complete:paru:*' fzf-preview 'paru -Si $word 2>/dev/null || paru -Qi $word 2>/dev/null || echo "Package not found"'
elif command -v yay &>/dev/null; then
  zstyle ':fzf-tab:complete:yay:*' fzf-preview 'yay -Si $word 2>/dev/null || yay -Qi $word 2>/dev/null || echo "Package not found"'
fi


# Fallback - no preview for anything else
zstyle ':fzf-tab:complete:*:*' fzf-preview ''
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit -d "$ZCACHEDIR/.zcompdump"
else
  compinit -C -d "$ZCACHEDIR/.zcompdump"
fi

# Set up eza
if command -v eza &>/dev/null; then
  # Define function with compdef
  function ls() {
    eza --icons --color=auto -F "$@"
  }
  compdef ls=ls
  
  # Define tree alias
  alias lt="eza --icons --tree --color=auto -F"
fi
