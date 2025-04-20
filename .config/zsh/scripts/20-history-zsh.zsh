#!/usr/bin/env zsh

# History file configuration
HISTFILE="$ZHISTDIR/history"
HISTSIZE=50000
SAVEHIST=20000

# History options
setopt EXTENDED_HISTORY       # Save timestamp and duration
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first
setopt HIST_IGNORE_DUPS       # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS   # Delete old entry if new is duplicate
setopt HIST_FIND_NO_DUPS      # Don't display duplicates in search
setopt HIST_IGNORE_SPACE      # Don't record entries starting with a space
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt HIST_VERIFY            # Show command before running from history
setopt INC_APPEND_HISTORY     # Write to history immediately
setopt SHARE_HISTORY          # Share history between all sessions

# Key bindings for history navigation
bindkey '^[[A' up-line-or-search    # Up arrow
bindkey '^[[B' down-line-or-search  # Down arrow
bindkey '^R' history-incremental-search-backward # Ctrl+R
