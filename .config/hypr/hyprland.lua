-- Hyprland config, Lua format (>= 0.55).
-- Converted from hyprland.conf (hyprlang), which is kept as a reference.
-- Docs: https://wiki.hypr.land/Configuring/Start/

--
-- Theme --
--
local c = require("themes.rose-pine")

--
-- Ecosystem --
--
hl.config({
    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },
})

--
-- Exec --
--
hl.on("hyprland.start", function()
    -- cursor
    hl.exec_cmd('hyprctl setcursor "BreezeX-RoséPine" 26')
    -- bar and wallpaper
    hl.exec_cmd("uwsm app -- hyprpanel")
    -- automount
    hl.exec_cmd("uwsm app -- udiskie")
    -- app launcher
    hl.exec_cmd("uwsm app -- hyprlauncher -d")
end)

--
-- Monitors --
--
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 })
hl.monitor({
    output   = "desc:Dell Inc. DELL S2722QC 7901MD3",
    mode     = "3840x2160@60",
    position = "1920x0",
    scale    = 1.5,
})
hl.monitor({
    output   = "desc:Dell Inc. DELL S2722QC DBX9MD3",
    mode     = "3840x2160@60",
    position = "4480x0",
    scale    = 1.5,
})

--
-- Workspaces --
--
-- Workspaces are pinned to monitors by description, so the same physical
-- display always owns the same workspaces. Hotplug is handled natively:
-- on disconnect Hyprland records the owning monitor per workspace and moves
-- them to a surviving one, on reconnect it moves them back.
-- (replaces scripts/workspaces.sh)
local wsMonitors = {
    ["eDP-1"]                               = { 1, 2, 3 },
    ["desc:Dell Inc. DELL S2722QC 7901MD3"] = { 4, 5, 6, 7 },
    ["desc:Dell Inc. DELL S2722QC DBX9MD3"] = { 8, 9, 10 },
}
for mon, ids in pairs(wsMonitors) do
    for _, i in ipairs(ids) do
        hl.workspace_rule({ workspace = tostring(i), monitor = mon, persistent = true })
    end
end

hl.workspace_rule({ workspace = "special:scratchpad", gaps_in = 50, gaps_out = 50 })

--
-- Gestures --
--
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

--
-- Variables --
--
-- see https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        border_size = 2,
        col = {
            active_border   = c.rose,
            inactive_border = c.muted,
        },
        gaps_in           = 5,
        gaps_out          = 20,
        no_focus_fallback = true,
        resize_on_border  = true,
    },

    decoration = {
        rounding         = 4,
        active_opacity   = 1.0,
        inactive_opacity = 0.88,
        dim_inactive     = false,
        dim_strength     = 0.5,
        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = "0xee191724",
        },
        blur = {
            size       = 8,
            passes     = 1,
            noise      = 0.0117,
            contrast   = 0.8916,
            brightness = 0.8172,
            vibrancy   = 0.1696,
        },
    },

    input = {
        kb_options           = "compose:ralt",
        resolve_binds_by_sym = true,
        repeat_rate          = 40,
        repeat_delay         = 300,
        touchpad = {
            natural_scroll          = true,
            middle_button_emulation = true,
        },
    },

    gestures = {
        workspace_swipe_distance           = 400,
        workspace_swipe_min_speed_to_force = 10,
        workspace_swipe_cancel_ratio       = 0.25,
        workspace_swipe_create_new         = false,
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        force_default_wallpaper  = 0,
        mouse_move_enables_dpms  = true,
        key_press_enables_dpms   = true,
        vrr                      = 1,
    },

    binds = {
        -- always focus the same window instead of the previous one
        -- focus_preferred_method = 1,
        movefocus_cycles_fullscreen = false,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    cursor = {
        inactive_timeout = 5,
    },
})

-- built-in keyboard overrides
hl.device({
    name       = "at-translated-set-2-keyboard",
    kb_variant = "colemak_dh",
    kb_options = "grp:alt_shift_toggle,caps:escape,compose:ralt",
})

-- mouse sensitivity
hl.device({ name = "razer-razer-deathadder-v3-hyperspeed",   sensitivity = -0.7 })
hl.device({ name = "razer-razer-deathadder-v3-hyperspeed-1", sensitivity = -0.7 })

--
-- Animations --
--
-- see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- bezier curves
-- see https://www.cssportal.com/css-cubic-bezier-generator/
hl.curve("easeoutsine",  { type = "bezier", points = { {0.39, 0.57},  {0.565, 1}     } })
hl.curve("easeoutquad",  { type = "bezier", points = { {0.25, 0.46},  {0.45, 0.94}   } })
hl.curve("easeoutcubic", { type = "bezier", points = { {0.215, 0.61}, {0.355, 1}     } })
hl.curve("easeoutquart", { type = "bezier", points = { {0.165, 0.84}, {0.44, 1}      } })
hl.curve("easeoutquint", { type = "bezier", points = { {0.23, 1},     {0.32, 1}      } })
hl.curve("easeoutexpo",  { type = "bezier", points = { {0.19, 1},     {0.22, 1}      } })
hl.curve("easeoutcirc",  { type = "bezier", points = { {0.075, 0.82}, {0.165, 1}     } })
hl.curve("easeoutback",  { type = "bezier", points = { {0.175, 0.885}, {0.32, 1.275} } })

-- animations
hl.animation({ leaf = "windows",          enabled = true, speed = 5, bezier = "easeoutquart", style = "popin 20%" })
hl.animation({ leaf = "fade",             enabled = true, speed = 2, bezier = "easeoutexpo" })
hl.animation({ leaf = "border",           enabled = true, speed = 3, bezier = "easeoutquad" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 5, bezier = "easeoutexpo", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "easeoutexpo", style = "slidefadevert 75%" })

--
-- Dwindle Layout --
--
-- see https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
    dwindle = {
        force_split          = 2,
        special_scale_factor = 0.8,
    },
})

--
-- Window Rules --
--
-- see https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({
    name  = "float-windows",
    match = { class = "foot-float|foot-full|kitty-float|kitty-full|ghostty-float|ghostty-full|pavucontrol|Lxappearance|simple-scan|blueman-manager|wdisplays|firewall-config|Loupe|Gimp|org.gnome.FileRoller" },
    float = true,
})

hl.window_rule({
    name       = "fullscreen-windows",
    match      = { class = "foot-full|kitty-full|ghostty-full" },
    fullscreen = true,
})

hl.window_rule({
    name         = "fullscreen-border",
    match        = { fullscreen = true },
    border_color = c.gold .. " " .. c.muted,
})

hl.window_rule({
    name    = "no-anim",
    match   = { class = [[gcr-prompter|org\.kde\.polkit-kde-authentication-agent-1]] },
    no_anim = true,
})

hl.window_rule({
    name         = "idle-inhibit",
    match        = { class = "firefox" },
    idle_inhibit = "fullscreen",
})

--
-- Keybindings --
--
-- see https://wiki.hypr.land/Configuring/Basics/Binds/
-- maintainance
-- quit hyprland
-- NOTE: uwsm users are advised to use `uwsm stop` instead of the exit dispatcher
hl.bind("SUPER + ALT + Q", hl.dsp.exit())

-- apps
-- launcher
hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprlauncher"))
-- emoji selector
hl.bind("SUPER + Period", hl.dsp.exec_cmd("rofimoji --max-recent 8"))
-- power menu
hl.bind("SUPER + X", hl.dsp.exec_cmd("nwg-bar"))
-- terminal
-- foot (waiting for ligature support)
-- hl.bind("SUPER + Return",         hl.dsp.exec_cmd("foot"))
-- hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("foot --app-id='foot-float'"))
-- hl.bind("SUPER + ALT + Return",   hl.dsp.exec_cmd("foot --app-id='foot-full' --fullscreen --font='Monospace:size=20' --override=pad=35x35"))
-- ghostty
hl.bind("SUPER + Return",         hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("ghostty --class='ghostty-float'"))
hl.bind("SUPER + ALT + Return",   hl.dsp.exec_cmd("ghostty --class='ghostty-full' --start-as=fullscreen --override font_size=20 --override window_padding_width=35"))

-- general
-- windows
hl.bind("SUPER + W",         hl.dsp.window.close())
hl.bind("SUPER + F",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + T",         hl.dsp.window.float({ action = "toggle" }))

-- screenshots
hl.bind("SUPER + S",               hl.dsp.exec_cmd("hyprshot -m region -o ~/screenshots"))
hl.bind("Print",                   hl.dsp.exec_cmd("hyprshot -m region -o ~/screenshots"))
hl.bind("SUPER + CTRL + S",        hl.dsp.exec_cmd("hyprshot -m window -o ~/screenshots"))
hl.bind("CTRL + Print",            hl.dsp.exec_cmd("hyprshot -m window -o ~/screenshots"))
hl.bind("SUPER + SHIFT + S",       hl.dsp.exec_cmd("hyprshot -m output -o ~/screenshots"))
hl.bind("SHIFT + Print",           hl.dsp.exec_cmd("hyprshot -m output -o ~/screenshots"))
hl.bind("SUPER + CTRL + ALT + S",  hl.dsp.exec_cmd("hyprshot -c -m window -o ~/screenshots"))
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.exec_cmd("hyprshot -c -m output -o ~/screenshots"))

-- colorpicker
hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprpicker -r -a"))

-- window info
hl.bind("SUPER + Slash", hl.dsp.exec_cmd([[notify-send "Window Info" "$(hyprctl activewindow | grep -E 'class|title')"]]))

-- lock
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- focus
-- direction
hl.bind("SUPER + M", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + N", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + E", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + I", hl.dsp.focus({ direction = "right" }))
-- direction (navigation)
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))

-- focus workspace
-- direction
hl.bind("SUPER + U", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + L", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + minus", hl.dsp.workspace.toggle_special(""))

-- focus monitor
-- direction
hl.bind("SUPER + J", hl.dsp.focus({ monitor = "-1" }))
hl.bind("SUPER + Y", hl.dsp.focus({ monitor = "+1" }))

-- move window
-- direction
hl.bind("SUPER + SHIFT + M", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + N", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + E", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + I", hl.dsp.window.move({ direction = "right" }))
-- direction (navigation)
hl.bind("SUPER + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))

-- move window to workspace
-- direction
hl.bind("SUPER + SHIFT + U", hl.dsp.window.move({ workspace = "m+1", follow = true }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ workspace = "m-1", follow = true }))
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.move({ workspace = "special", follow = true }))

-- move window to monitor
-- direction
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ monitor = "-1", follow = true }))
hl.bind("SUPER + SHIFT + Y", hl.dsp.window.move({ monitor = "+1", follow = true }))

-- resize window
-- direction
hl.bind("SUPER + ALT + M", hl.dsp.window.resize({ x = -10, y = 0,   relative = true }))
hl.bind("SUPER + ALT + N", hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }))
hl.bind("SUPER + ALT + E", hl.dsp.window.resize({ x = 0,   y = -10, relative = true }))
hl.bind("SUPER + ALT + I", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }))
-- direction (navigation)
hl.bind("SUPER + ALT + left",  hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })
hl.bind("SUPER + ALT + down",  hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
hl.bind("SUPER + ALT + up",    hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + right", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })

-- brightness
hl.bind("CTRL + XF86MonBrightnessUp",    hl.dsp.exec_cmd("brightnessctl -d intel_backlight -c backlight set +1%"),  { repeating = true })
hl.bind("CTRL + XF86MonBrightnessDown",  hl.dsp.exec_cmd("brightnessctl -d intel_backlight -c backlight set 1%-"),  { repeating = true })
hl.bind("XF86MonBrightnessUp",           hl.dsp.exec_cmd("brightnessctl -d intel_backlight -c backlight set +5%"),  { repeating = true })
hl.bind("XF86MonBrightnessDown",         hl.dsp.exec_cmd("brightnessctl -d intel_backlight -c backlight set 5%-"),  { repeating = true })
hl.bind("SHIFT + XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -d intel_backlight -c backlight set +10%"), { repeating = true })
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d intel_backlight -c backlight set 10%-"), { repeating = true })

-- media
hl.bind("CTRL + XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%+"),  { repeating = true })
hl.bind("CTRL + XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),         { repeating = true })
hl.bind("XF86AudioRaiseVolume",         hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),  { repeating = true })
hl.bind("XF86AudioLowerVolume",         hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),         { repeating = true })
hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 10%+"), { repeating = true })
hl.bind("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),        { repeating = true })
hl.bind("XF86AudioMute",                hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),        { repeating = true })
hl.bind("CTRL + XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),      { repeating = true })
hl.bind("XF86AudioPlay",                hl.dsp.exec_cmd("playerctl play"),                                    { repeating = true })
hl.bind("XF86AudioPause",               hl.dsp.exec_cmd("playerctl pause"),                                   { repeating = true })
hl.bind("XF86AudioStop",                hl.dsp.exec_cmd("playerctl stop"),                                    { repeating = true })
hl.bind("XF86AudioNext",                hl.dsp.exec_cmd("playerctl next"),                                    { repeating = true })
hl.bind("XF86AudioPrev",                hl.dsp.exec_cmd("playerctl prev"),                                    { repeating = true })

-- mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
