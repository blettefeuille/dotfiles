#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Override ls to use eza
ls() {
    # Check if eza is installed
    if command -v eza &>/dev/null; then
        # Use eza with some default options
        eza --color=auto --group-directories-first --icons "$@"
    else
        # Fall back to regular ls if eza is not installed
        command ls --color=auto "$@"
    fi
}

alias ll='eza -l --group-directories-first --icons'
alias la='eza -a --group-directories-first --icons'
alias l='eza -1 --group-directories-first --icons'

