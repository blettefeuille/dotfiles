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
