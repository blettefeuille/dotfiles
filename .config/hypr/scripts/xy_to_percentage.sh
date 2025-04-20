#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <X> <Y>"
    exit 1
fi

# Convert to integers
CURSOR_X=$(printf "%.0f" "$1")
CURSOR_Y=$(printf "%.0f" "$2")

# Get monitor info using updated hyprctl format
hyprctl monitors | awk -v cx="$CURSOR_X" -v cy="$CURSOR_Y" '
/^Monitor/ { mon=$2 }
/^[[:space:]]+[0-9]+x[0-9]+@/ {
    # resolution@refresh at posXxposY
    match($1, /([0-9]+)x([0-9]+)/, res)
    match($4, /([0-9]+)x([0-9]+)/, pos)
    resx = res[1]
    resy = res[2]
    monx = pos[1]
    mony = pos[2]

    # Is cursor in this monitor?
    if (cx >= monx && cx <= monx + resx &&
        cy >= mony && cy <= mony + resy) {
        relx = (cx - monx) / resx
        rely = (cy - mony) / resy
        printf "%.4f %.4f\n", relx, rely
        exit
    }
}

END {
    if (!relx) {
        print "Could not determine monitor for position " cx, cy > "/dev/stderr"
        exit 1
    }
}'

