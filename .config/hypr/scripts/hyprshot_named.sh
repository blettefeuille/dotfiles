#!/bin/bash

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

FILENAME="Screenshot_$(date +'%Y_%m_%d_%H_%M').png"
FILEPATH="$SAVE_DIR/$FILENAME"

MODE="$1"         # output | region | window
FREEZE="$2"       # optional: "freeze"

# Build the command
CMD=(hyprshot -m "$MODE" -o "$FILEPATH")

# Add freeze if requested
if [[ "$FREEZE" == "freeze" ]]; then
    CMD+=(--freeze)
fi

echo "${CMD[@]}"
# Run screenshot command
"${CMD[@]}"

# Copy to clipboard
wl-copy < "$FILEPATH"

