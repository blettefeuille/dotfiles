#!/usr/bin/env bash

# Catppuccin Mocha color palette
ROSEWATER='\033[38;5;222m'   # #F5D0C5
FLAMINGO='\033[38;5;217m'    # #F2CDCD
PINK='\033[38;5;213m'        # #F5A9B8
MAUVE='\033[38;5;141m'       # #C6A0F6
BLUE='\033[38;5;117m'        # #89B4FA
LAVENDER='\033[38;5;138m'    # #B4B8D3
GREEN='\033[38;5;114m'       # #A6D189
YELLOW='\033[38;5;226m'      # #F9E2AF
RED='\033[38;5;161m'         # #F38BA8
TEAL='\033[38;5;81m'         # #94E2D5
SKY='\033[38;5;110m'         # #74C7EC
NEUTRAL='\033[38;5;145m'     # #CDD6F4
RESET='\033[0m'

if [[ $# -ne 1 ]]; then
  >&2 echo -e "${RED}❌ usage: $0 FILENAME[:LINENO][:IGNORED]${RESET}"
  exit 1
fi

file=${1/#\~\//$HOME/}

center=0
if [[ ! -r $file ]]; then
  if [[ $file =~ ^(.+):([0-9]+)\ *$ ]] && [[ -r ${BASH_REMATCH[1]} ]]; then
    file=${BASH_REMATCH[1]}
    center=${BASH_REMATCH[2]}
  elif [[ $file =~ ^(.+):([0-9]+):[0-9]+\ *$ ]] && [[ -r ${BASH_REMATCH[1]} ]]; then
    file=${BASH_REMATCH[1]}
    center=${BASH_REMATCH[2]}
  fi
fi

if [[ ! -f "$file" ]]; then
  echo -e "${RED}❌ File does not exist!${RESET}"
  exit 1
fi

type=$(file --brief --dereference --mime -- "$file")

# Get terminal dimensions from FZF or fallback to tput
preview_width=${FZF_PREVIEW_COLUMNS:-$(tput cols)}
preview_height=${FZF_PREVIEW_LINES:-$(tput lines)}

# Calculate available height for content after header (approx 8 lines for header)
content_lines=$((preview_height - 8))
if [[ $content_lines -lt 1 ]]; then
  content_lines=10  # minimum content height
fi

# Dynamic separator generation function
generate_separator() {
  local width=$((preview_width - 2))  # account for box borders
  printf -v separator '━%.0s' $(seq 1 $width)
  echo "$separator"
}

# Generate dynamic separators
top_separator=$(generate_separator)
bottom_separator=$(generate_separator)
content_separator=$(generate_separator)

# Print file info header
echo -e "${BLUE}📁✨ File Info${RESET}"

# Get file metadata
created=$(stat --format="%w" "$file")
modified=$(stat --format="%y" "$file")
[[ "$created" == "-" ]] && created="$modified"
created_fmt=$(date -d "$created" '+%Y-%m-%d %H:%M')
modified_fmt=$(date -d "$modified" '+%Y-%m-%d %H:%M')
creator=$(stat --format="%U" "$file")
filename=$(basename "$file")

# Framed file info block with dynamic width
echo -e "${MAUVE}╭${top_separator}╮${RESET}"
printf "${MAUVE}│${RESET} ${BLUE}📄  Name      :${RESET} %-${preview_width}s ${MAUVE}│${RESET}\n" "$filename"
printf "${MAUVE}│${RESET} ${GREEN}👤  Owner     : %-${preview_width}s ${MAUVE}│${RESET}\n" "${creator:-'Unknown'}"
printf "${MAUVE}│${RESET} ${PINK}📅  Created   : %-${preview_width}s ${MAUVE}│${RESET}\n" "${created_fmt:-'Unknown'}"
printf "${MAUVE}│${RESET} ${TEAL}🕓  Modified  : %-${preview_width}s ${MAUVE}│${RESET}\n" "${modified_fmt}"
echo -e "${MAUVE}╰${bottom_separator}╯${RESET}"

echo -e "${TEAL}🧾 Preview${RESET}"
echo -e "${SKY}${content_separator}${RESET}"

# Handle different file types
if [[ $type =~ image/ ]]; then
  # Image preview with FZF dimension handling
  if [[ $KITTY_WINDOW_ID ]] || [[ $GHOSTTY_RESOURCES_DIR ]] && command -v kitten > /dev/null; then
    kitten icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="${preview_width}x${content_lines}@0x0" "$file" | sed '$d' | sed $'$s/$/\e[m/'
  elif command -v chafa > /dev/null; then
    chafa -s "${preview_width}x${content_lines}" "$file"
    echo
  elif command -v imgcat > /dev/null; then
    imgcat -W "${preview_width}" -H "${content_lines}" "$file"
  else
    file "$file"
  fi
elif [[ $type =~ =binary ]]; then
  file "$file"
else
  # Text file preview with syntax highlighting
  if [[ $type =~ json ]]; then
    jq . "$file" 2>/dev/null | bat --language=json --style=plain --color=always --line-range=:$content_lines
  elif [[ $type =~ markdown ]]; then
    glow --style dark --width "${preview_width}" "$file" | head -n $content_lines
  else
    bat --style="${BAT_STYLE:-numbers}" --color=always --pager=never --highlight-line="${center:-0}" --line-range=:$content_lines -- "$file"
  fi
fi
