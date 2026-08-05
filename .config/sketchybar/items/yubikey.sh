#!/bin/bash

# The one widget that gets a filled love pill. The rule everywhere else is a
# love border over the overlay, because a permanent widget shouting in red is
# just noise; this one only draws at all while something is blocked waiting for
# you to touch the key, which is precisely when noise is the point. It matches
# the waybar module on Linux.
#
# The glyph is a UTF-8 byte escape, not a literal: private-use characters get
# stripped on their way into these files. U+F0306 is nf-md-key_wireless, the
# same glyph the waybar module uses.
YUBIKEY_ICON=$(printf '\xf3\xb0\x8c\x86')

# Icon-only, so icon.padding_right has to act as the pill's right edge. An empty
# label is not a free one: its inherited 5pt and 11pt insets still take part in
# the layout, so a label-less pill carries 16pt of dead space on the right unless
# the label is switched off outright.
sketchybar --add event yubikey_touch \
           --add item yubikey right \
           --set yubikey \
             drawing=off \
             icon="$YUBIKEY_ICON" \
             icon.color="$BASE" \
             icon.padding_right=11 \
             label.drawing=off \
             background.color="$LOVE" \
             background.drawing=on \
             script="$PLUGIN_DIR/yubikey.sh" \
           --subscribe yubikey yubikey_touch
