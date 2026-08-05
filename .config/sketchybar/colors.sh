# Rosé Pine (dark), canonical values from the palette spec.
# https://rosepinetheme.com/palette/ingredients/

# surfaces, darkest to lightest
export BASE=0xff191724
export SURFACE=0xff1f1d2e
export OVERLAY=0xff26233a
export HIGHLIGHT_LOW=0xff21202e
export HIGHLIGHT_MED=0xff403d52
export HIGHLIGHT_HIGH=0xff524f67

# foreground, quietest to loudest
export MUTED=0xff6e6a86
export SUBTLE=0xff908caa
export TEXT=0xffe0def4

# Off-palette: subtle/text 60:40, 30% toward rose, scaled to 5.19:1 on overlay.
export SUBTLE_LIGHT=0xffa092a1

# Near-white with a faint warm cast, so labels sit with rose rather than against
# it. TEXT stays for anything meant to be ambient.
export WHITE=0xfffdf8f6

# accents
export LOVE=0xffeb6f92
export GOLD=0xfff6c177
export ROSE=0xffebbcba
export PINE=0xff31748f
export FOAM=0xff9ccfd8
export IRIS=0xffc4a7e7

export TRANSPARENT=0x00ffffff

# Only one thing on the bar gets a filled rose pill — the focused workspace — so
# focus is never ambiguous. Every widget then owns one accent and no two
# neighbours share it: gold for the network link, iris for audio, pine for the
# clock, rose for now-playing, love for the Slack badge. Battery is the one
# exception and escalates through white to gold to love as charge drops.
export ACCENT_COLOR=$ROSE

# The bar itself draws nothing; kept for anything wanting a translucent base.
export BAR_COLOR=0x66191724

# kept so any older reference still resolves
export BACKGROUND=$BASE
export BACKGROUND_LIGHT=$OVERLAY
export RED=$LOVE
