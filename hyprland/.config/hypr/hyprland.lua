-- Hashiru Hyprland Configuration (Lua, 0.55+)
-- https://wiki.hypr.land/

require("monitors")
require("autostart")
require("keybinds")
require("windowrules")

-- -----------------------------------------------------------------------------
-- Environment
-- -----------------------------------------------------------------------------

hl.env("XCURSOR_THEME",     "Adwaita")
hl.env("XCURSOR_SIZE",      "24")
hl.env("HYPRCURSOR_THEME",  "Adwaita")
hl.env("HYPRCURSOR_SIZE",   "24")
hl.env("GTK_THEME",         "Adwaita:Dark")
hl.env("QT_STYLE_OVERRIDE", "Adwaita-Dark")

-- -----------------------------------------------------------------------------
-- General / Input / Decoration / Layouts / Misc
-- -----------------------------------------------------------------------------

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(7aa2f7ee)", "rgba(9ece6aee)" }, angle = 45 },
            inactive_border = "rgba(414868aa)",
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    input = {
        kb_layout    = "us",
        kb_options   = "caps:super",
        repeat_rate  = 80,
        repeat_delay = 200,
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            drag_lock            = true,
            disable_while_typing = true,
        },
    },

    gestures = {
        workspace_swipe_distance     = 300,
        workspace_swipe_cancel_ratio = 0.5,
    },

    decoration = {
        rounding = 2,
        blur = {
            enabled    = true,
            size       = 3,
            passes     = 2,
            noise      = 0.0117,
            brightness = 0.8,
            contrast   = 1,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
        smart_split    = false,
        smart_resizing = true,
        force_split    = 2,
    },

    master = {
        new_status = "master",
    },

    group = {
        col = {
            border_active   = "rgba(4a7fcfee)",
            border_inactive = "rgba(0d1f3caa)",
        },
        groupbar = {
            enabled              = true,
            font_size            = 12,
            font_family          = "monospace",
            font_weight_active   = "ultraheavy",
            font_weight_inactive = "normal",
            indicator_height     = 0,
            indicator_gap        = 5,
            height               = 22,
            gaps_in              = 5,
            gaps_out             = 0,
            text_color           = "rgb(c0caf5)",
            text_color_inactive  = "rgba(c0caf570)",
            col = {
                active   = "rgba(00000090)",
                inactive = "rgba(00000090)",
            },
            gradients                 = true,
            gradient_rounding         = 0,
            gradient_round_only_edges = false,
        },
    },

    misc = {
        force_default_wallpaper    = 0,
        disable_hyprland_logo      = true,
        disable_splash_rendering   = true,
        mouse_move_enables_dpms    = true,
        key_press_enables_dpms     = true,
        on_focus_under_fullscreen  = 1,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

-- -----------------------------------------------------------------------------
-- Gestures
-- -----------------------------------------------------------------------------

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- -----------------------------------------------------------------------------
-- Animations (macOS-style)
-- -----------------------------------------------------------------------------

-- macOS-style beziers
hl.curve("easeOutExpo",    { type = "bezier", points = { { 0.16, 1 },  { 0.3, 1 }  } }) -- fast start, smooth deceleration
hl.curve("easeOutQuart",   { type = "bezier", points = { { 0.25, 1 },  { 0.5, 1 }  } }) -- gentler ease-out for fades/close
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0 },  { 0.35, 1 } } }) -- balanced for workspace slides

-- Window open/close/move
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 4, bezier = "easeOutExpo",  style = "popin 85%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3, bezier = "easeOutQuart", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "easeOutExpo" })

-- Workspace transitions
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "easeInOutCubic", style = "slide" })

-- Fade for popups, tooltips, etc.
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "easeOutQuart" })

-- Layers (waybar, rofi, notifications)
hl.animation({ leaf = "layers",    enabled = true, speed = 3, bezier = "easeOutExpo",  style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "easeOutQuart", style = "fade" })
