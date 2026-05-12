-- Keybindings
-- Super (Windows key) as main modifier

local mod         = "SUPER"
local env_prefix  = "env EDITOR=nvim VISUAL=nvim"
local terminal    = env_prefix .. " kitty"
local browser     = "chromium"
local filemanager = "thunar"
local menu        = "fuzzel"

-- -----------------------------------------------------------------------------
-- Help
-- -----------------------------------------------------------------------------

hl.bind(mod .. " + slash", hl.dsp.exec_cmd("/home/whleucka/.bin/scripts/keybinds"), { description = "Show keybinds" })

-- -----------------------------------------------------------------------------
-- Applications
-- -----------------------------------------------------------------------------

hl.bind(mod .. " + Return",         hl.dsp.exec_cmd(terminal),                       { description = "Terminal" })
hl.bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal .. " ks attach home"),  { description = "Terminal (ks home)" })
hl.bind(mod .. " + Space",          hl.dsp.exec_cmd(menu),                           { description = "App launcher" })

hl.bind(mod .. " + SHIFT + I", hl.dsp.exec_cmd(browser .. " --app=https://cibc.com"),                                    { description = "Banking" })
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd(browser .. " --app=https://bsky.app"),                                    { description = "Bluesky" })
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("gnome-calculator"),                                                      { description = "Calculator" })
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd(terminal .. " lazydocker"),                                               { description = "Lazydocker" })
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd(browser .. " --app=https://mail.google.com"),                             { description = "Email" })
hl.bind(mod .. " + SHIFT + F", hl.dsp.exec_cmd(filemanager),                                                             { description = "File manager" })
hl.bind(mod .. " + SHIFT + G", hl.dsp.exec_cmd(browser .. " --app=https://github.com"),                                  { description = "GitHub" })
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd(terminal .. " nvim"),                                                     { description = "Notes" })
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd(browser .. " --app=https://messages.google.com/web/conversations"),       { description = "Messages" })
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd(browser .. " --app=https://reddit.com"),                                  { description = "Reddit" })
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("spotify"),                                                               { description = "Spotify" })
hl.bind(mod .. " + SHIFT + T", hl.dsp.exec_cmd(terminal .. " btop"),                                                     { description = "System monitor (btop)" })
hl.bind(mod .. " + SHIFT + U", hl.dsp.exec_cmd(terminal .. " -e yay -Syu | -y", { float = true, size = { 900, 600 }, center = true }), { description = "Update system" })
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd(browser),                                                                 { description = "Browser" })
hl.bind(mod .. " + SHIFT + Y", hl.dsp.exec_cmd(browser .. " --app=https://youtube.com"),                                 { description = "YouTube" })

-- -----------------------------------------------------------------------------
-- Window Management
-- -----------------------------------------------------------------------------

hl.bind(mod .. " + Q",         hl.dsp.window.close(),                                          { description = "Close window" })
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit(),                                                  { description = "Exit Hyprland" })
hl.bind(mod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Fullscreen" })
hl.bind(mod .. " + M",         hl.dsp.window.fullscreen({ mode = "maximized",  action = "toggle" }), { description = "Maximize" })
hl.bind(mod .. " + T",         hl.dsp.window.float({ action = "toggle" }),                     { description = "Toggle floating" })
hl.bind(mod .. " + SEMICOLON", hl.dsp.layout("togglesplit"),                                   { description = "Toggle split" })

-- Toggle layout (dwindle/monocle) — read current layout via hyprctl and swap
hl.bind(mod .. " + O", hl.dsp.exec_cmd([[hyprctl keyword general:layout $([ "$(hyprctl getoption general:layout -j | jq -r '.str')" = "dwindle" ] && echo "monocle" || echo "dwindle")]]), { description = "Toggle layout (dwindle/monocle)" })

-- Focus (vim keys)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

-- Monocle cycle (separate keys so cycleprev/cyclenext don't error in dwindle)
hl.bind(mod .. " + Tab",         hl.dsp.layout("cycleprev"), { description = "Previous window (monocle)" })
hl.bind(mod .. " + SHIFT + Tab", hl.dsp.layout("cyclenext"), { description = "Next window (monocle)" })

-- Move windows (vim keys)
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })

-- Resize hold -/+ (code:20 = `-`, code:21 = `=`/`+`)
hl.bind("SUPER + code:20",         hl.dsp.window.resize({ x = -25, y = 0,   relative = true }), { repeating = true })
hl.bind("SUPER + code:21",         hl.dsp.window.resize({ x = 25,  y = 0,   relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + code:20", hl.dsp.window.resize({ x = 0,   y = -25, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + code:21", hl.dsp.window.resize({ x = 0,   y = 25,  relative = true }), { repeating = true })

-- Resize submap
hl.bind(mod .. " + R", hl.dsp.submap("resize"), { description = "Resize mode" })
hl.define_submap("resize", function()
    hl.bind("H", hl.dsp.window.resize({ x = -25, y = 0,   relative = true }), { repeating = true })
    hl.bind("L", hl.dsp.window.resize({ x = 25,  y = 0,   relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0,   y = -25, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0,   y = 25,  relative = true }), { repeating = true })
    hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- -----------------------------------------------------------------------------
-- Workspaces
-- -----------------------------------------------------------------------------

for i = 1, 9 do
    hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }),                        { description = "Workspace " .. i })
    hl.bind("SUPER + SHIFT + " .. i,     hl.dsp.window.move({ workspace = i, follow = false }),  { description = "Move window to workspace " .. i })
end
hl.bind(mod .. " + 0",         hl.dsp.focus({ workspace = 10 }),                        { description = "Workspace 10" })
hl.bind("SUPER + SHIFT + 0",     hl.dsp.window.move({ workspace = 10, follow = false }),  { description = "Move window to workspace 10" })

-- Special workspace (scratchpad)
hl.bind(mod .. " + Home",   hl.dsp.workspace.toggle_special("magic"),               { description = "Toggle scratchpad" })
hl.bind(mod .. " + Insert", hl.dsp.window.move({ workspace = "special:magic" }),    { description = "Move to scratchpad" })
hl.bind(mod .. " + Delete", hl.dsp.window.move({ workspace = "e+0" }),              { description = "Remove from scratchpad" })

-- -----------------------------------------------------------------------------
-- Grouped Windows (Tabs)
-- -----------------------------------------------------------------------------

hl.bind(mod .. " + G",           hl.dsp.group.toggle(),                              { description = "Toggle group" })
hl.bind(mod .. " + D",           hl.dsp.window.move({ out_of_group = true }),        { description = "Move out of group" })
hl.bind("SUPER + bracketleft",   hl.dsp.group.prev(),                                { description = "Previous group tab" })
hl.bind("SUPER + bracketright",  hl.dsp.group.next(),                                { description = "Next group tab" })
hl.bind(mod .. " + CTRL + H",    hl.dsp.window.move({ into_group = "l" }),           { description = "Group left" })
hl.bind(mod .. " + CTRL + L",    hl.dsp.window.move({ into_group = "r" }),           { description = "Group right" })
hl.bind(mod .. " + CTRL + K",    hl.dsp.window.move({ into_group = "u" }),           { description = "Group up" })
hl.bind(mod .. " + CTRL + J",    hl.dsp.window.move({ into_group = "d" }),           { description = "Group down" })
hl.bind(mod .. " + ALT + G",     hl.dsp.group.lock_active({ action = "toggle" }),    { description = "Lock group" })

-- -----------------------------------------------------------------------------
-- Mouse bindings
-- -----------------------------------------------------------------------------

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- -----------------------------------------------------------------------------
-- Clipboard / Color picker
-- -----------------------------------------------------------------------------

hl.bind(mod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"), { description = "Clipboard history" })
hl.bind(mod .. " + C", hl.dsp.exec_cmd("hyprpicker -r"),                                              { description = "Color picker" })

-- -----------------------------------------------------------------------------
-- Screenshots
-- -----------------------------------------------------------------------------

hl.bind("Print",            hl.dsp.exec_cmd("/home/whleucka/.bin/scripts/screenshot-region"), { description = "Screenshot region" })
hl.bind(mod .. " + Print",  hl.dsp.exec_cmd("/home/whleucka/.bin/scripts/screenshot"),        { description = "Screenshot full" })

-- -----------------------------------------------------------------------------
-- Screen recording
-- -----------------------------------------------------------------------------

hl.bind(mod .. " + ALT + R",  hl.dsp.exec_cmd([[sh -c 'wl-screenrec -g "$(slurp)" -f $HOME/Videos/recording_$(date +%Y%m%d_%H%M%S).mp4']]), { description = "Record selected region" })
hl.bind(mod .. " + CTRL + R", hl.dsp.exec_cmd("killall -s SIGINT wl-screenrec"),                                                            { description = "Stop recording" })

-- -----------------------------------------------------------------------------
-- Media / Hardware keys
-- -----------------------------------------------------------------------------

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"),       { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"),       { repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"))

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { repeating = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))

-- -----------------------------------------------------------------------------
-- Lock
-- -----------------------------------------------------------------------------

hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"), { description = "Lock screen" })

-- -----------------------------------------------------------------------------
-- Notifications
-- -----------------------------------------------------------------------------

hl.bind(mod .. " + period",        hl.dsp.exec_cmd("makoctl restore"),       { description = "Restore notification" })
hl.bind(mod .. " + comma",         hl.dsp.exec_cmd("makoctl dismiss"),       { description = "Dismiss notification" })
hl.bind(mod .. " + SHIFT + comma", hl.dsp.exec_cmd("makoctl dismiss --all"), { description = "Dismiss all notifications" })
