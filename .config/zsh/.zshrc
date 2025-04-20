#!/usr/bin/env zsh
# ===== Core Setup =====
# Enable profiling (uncomment to use)
# export ZSH_PROFILE=true

# Start timer for performance analysis
if [[ -n "$ZSH_PROFILE" ]]; then
  zmodload zsh/datetime
  setopt PROMPT_SUBST
  PS4='+$EPOCHREALTIME ${(l:${(#)LINENO}::0:):LINENO} ${funcstack[0]:+${funcstack[0]}:}${(l:${#funcfiletrace[1]#*:}::0:):${funcfiletrace[1]#*:}} '
  exec 3>&2 2>$ZDOTDIR/.zsh_profile.$$
  setopt XTRACE
  _profile_start=$EPOCHREALTIME
fi

# Load environment variables (if not already loaded by system)
[[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"
# Set ZDOTDIR if not set (optional, but ensures consistency)
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
# Source each script in the ZDOTDIR/scripts directory
for script in "$ZDOTDIR/scripts/"*.zsh; do
  if [[ -f "$script" ]]; then
    source "$script" || echo "Error loading $script" >&2
  fi
done
setopt interactivecomments
# ===== Tools Initialization =====
# Initialize zoxide (smart 'cd' replacement)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  echo "zoxide not installed (visit github.com/ajeetdsouza/zoxide for installation)" >&2
fi

# Initialize syntax highlighting (must be last!)
if [[ -f "$ZPLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZPLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
  echo "Syntax highlighting plugin missing! Run: install_plugin https://github.com/zsh-users/zsh-syntax-highlighting" >&2
fi

# Stop profiling
if [[ -n "$ZSH_PROFILE" ]]; then
  unsetopt XTRACE
  exec 2>&3 3>&-
  echo "Shell startup completed in $(( EPOCHREALTIME - _profile_start ))s"
  echo "Profile saved to $ZDOTDIR/.zsh_profile.$$"
  zprof
fi
