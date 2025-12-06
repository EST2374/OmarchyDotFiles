#!/bin/bash

INPUT_FILE="alacritty.toml"

# Get the absolute path of the current directory
current_path="$(pwd)"
# Get the last component of the path (the theme name)
last_directory=$(echo "$current_path" | awk -F'/' '{print $NF}')
dest_path="/usr/share/ghostty/themes/"

# The AWK output file (the actual color definitions) will be named after the theme
OUTPUT_FILE="$dest_path$last_directory"

# 1. Create the ghostty.conf file in the current directory with the theme name
# This file is used for configuration *within* the theme directory structure
rm -f ghostty.conf
echo "theme = $last_directory" >> ghostty.conf
REALUSER="${SUDO_USER:-$USER}"

sudo chown -R "$REALUSER":"$REALUSER" ghostty.conf

# Temporary file for AWK output
TEMP_AWK_OUTPUT="$(mktemp /tmp/alacritty2ghostty.XXXXXX)"

# AWK: parse alacritty.toml-ish structure and print Ghostty palette lines
awk '
BEGIN {
    section = ""
    # Initialize arrays
}
# Detect section headers like [colors], [colors.primary], [colors.normal], [colors.bright], [colors.selection]
/^\s*\[.*\]\s*$/ {
    # strip brackets and whitespace
    header = $0
    gsub(/^\s*\[/, "", header)
    gsub(/\]\s*$/, "", header)
    gsub(/^[ \t]+|[ \t]+$/, "", header)
    section = header
    next
}
# Parse simple assignments: key = "value"  or key = '\''#hex'\'' or key = #hex without quotes
/=/ {
    line = $0
    # ignore commented lines
    if (line ~ /^\s*#/) next

    # extract key and value (value may contain quotes or single quotes)
    if (match(line, /^[ \t]*([a-zA-Z0-9_.-]+)[ \t]*=[ \t]*["'\'']?([^"'\''#][^"'\'' ]*|#[0-9a-fA-F]{6}|[0-9a-fA-F]{6})["'\'']?/, m)) {
        key = m[1]
        val = m[2]
    } else if (match(line, /^[ \t]*([a-zA-Z0-9_.-]+)[ \t]*=[ \t]*["'\'']?([^"'\'' ]+)["'\'']?/, m2)) {
        key = m2[1]
        val = m2[2]
    } else {
        next
    }

    # normalize value to ensure it starts with #
    if (val ~ /^[0-9a-fA-F]{6}$/) val = "#" val
    if (val ~ /^#[0-9a-fA-F]{6}$/) {
        # store according to section
        if (section == "colors.primary") {
            primary[key] = val
        } else if (section == "colors.normal") {
            normal[key] = val
        } else if (section == "colors.bright") {
            bright[key] = val
        } else if (section == "colors.selection") {
            selection[key] = val
        } else if (section == "colors") {
            # sometimes direct colors appear under [colors]
            colors[key] = val
        }
    }
    next
}

END {
    # Determine background and foreground
    bg = primary["background"]
    fg = primary["foreground"]
    if (bg == "") bg = colors["background"]
    if (fg == "") fg = colors["foreground"]
    if (bg == "") bg = "#000000"
    if (fg == "") fg = "#ffffff"

    # Prepare palette order (normal 0-7 then bright 8-15)
    order_normal[0] = "black"; order_normal[1] = "red"; order_normal[2] = "green"; order_normal[3] = "yellow"
    order_normal[4] = "blue"; order_normal[5] = "magenta"; order_normal[6] = "cyan"; order_normal[7] = "white"

    # print normal colors (0-7)
    for (i=0; i<8; i++) {
        name = order_normal[i]
        val = normal[name]
        if (val == "") val = "#000000"
        printf("palette = %d=%s\n", i, val)
    }

    # print bright colors (8-15)
    for (i=0; i<8; i++) {
        name = order_normal[i]
        idx = i + 8
        val = bright[name]
        if (val == "") val = normal[name]
        if (val == "") val = "#000000"
        printf("palette = %d=%s\n", idx, val)
    }

    # selection/background/foreground/cursor heuristics
    sel_bg = selection["background"]
    if (sel_bg == "") sel_bg = "#000000"

    # cursor-color prefer primary.cursor or fallback to foreground
    cursor_color = primary["cursor"]
    if (cursor_color == "") cursor_color = fg

    # For cursor-text, if there is a cursor foreground defined, use it; else choose a contrasting fallback:
    cursor_text = primary["cursor_text"]
    if (cursor_text == "") {
        # fallback: if background light/dark heuristic (simple luminance)
        # convert hex to r,g,b
        hex = substr(bg,2)
        r = strtonum("0x" substr(hex,1,2))
        g = strtonum("0x" substr(hex,3,2))
        b = strtonum("0x" substr(hex,5,2))
        lum = 0.2126*r + 0.7152*g + 0.0722*b
        if (lum < 128) cursor_text = "#ffffff"
        else cursor_text = "#000000"
    }

    # Print background, foreground, cursor and selection lines (use the names you requested)
    printf("background = %s\n", bg)
    printf("foreground = %s\n", fg)
    printf("cursor-color = %s\n", cursor_color)
    printf("cursor-text = %s\n", cursor_text)
    printf("selection-background = %s\n", sel_bg)
    # selection-foreground: choose fg of selection if available, else a contrast to sel_bg (use primary background)
    sel_fg = selection["foreground"]
    if (sel_fg == "") sel_fg = bg
    printf("selection-foreground = %s\n", sel_fg)
}
' "$INPUT_FILE" > "$TEMP_AWK_OUTPUT"

# Output the content from the temporary file to the final destination (local file)
cat "$TEMP_AWK_OUTPUT" > "$OUTPUT_FILE"

# Clean up the temporary file
rm "$TEMP_AWK_OUTPUT"

echo "Conversion successful."
echo "Created theme color file: '$OUTPUT_FILE' in the current directory."
echo "Created Ghostty config file: 'ghostty.conf' with the content 'theme = $last_directory'."

