#!/usr/bin/env zsh

# Basic navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Common tools with safer defaults
alias rm='rm -I'  # Less intrusive than -i, asks only for 3+ files
alias cp='cp -i'
alias mv='mv -i'

# Editor shortcuts
alias v='$EDITOR'
alias vi='$EDITOR'

# Quick access to config files
alias zreload='source $ZDOTDIR/.zshrc'

# Git shortcuts
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gd='git diff'

# Wayland clipboard
alias clip='wl-copy'
alias paste='wl-paste'

# System info
alias df='df -h'
alias free='free -h'
alias ip='ip -c'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
