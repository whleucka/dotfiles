-- Keybindings
-- Super (Windows key) as main modifier

local home         = os.getenv("HOME")
local hypr_scripts = home .. "/.config/hypr/scripts"
local mod          = "SUPER"
local env_prefix   = "env EDITOR=nvim VISUAL=nvim"
local terminal     = env_prefix .. " kitty"
local browser      = "chromium"
local filemanager  = "thunar"
local menu         = "fuzzel"

local function key(...)
  return table.concat({ ... }, " + ")
end

-- -----------------------------------------------------------------------------
-- Help
-- -----------------------------------------------------------------------------

hl.bind(key(mod, "slash"), hl.dsp.exec_cmd(hypr_scripts .. "/keybinds"), { description = "Show keybinds" })

-- -----------------------------------------------------------------------------
-- Applications
-- -----------------------------------------------------------------------------

hl.bind(key(mod, "Return"), hl.dsp.exec_cmd(terminal .. " ks attach home"), { description = "Terminal (tmux home)" })
hl.bind(key(mod, "SHIFT", "Return"),
  hl.dsp.exec_cmd(terminal .. " ks attach home", { float = true, size = { 900, 600 }, center = true }),
  { description = "Floating Terminal (tmux home)" })
hl.bind(key(mod, "Space"), hl.dsp.exec_cmd(menu), { description = "App launcher" })

hl.bind(key(mod, "SHIFT", "B"), hl.dsp.exec_cmd(browser .. " --app=https://cibc.com"), { description = "CIBC Banking" })
hl.bind(key(mod, "SHIFT", "C"), hl.dsp.exec_cmd("gnome-calculator"), { description = "Calculator" })
hl.bind(key(mod, "SHIFT", "D"), hl.dsp.exec_cmd(terminal .. " lazydocker"), { description = "Lazydocker" })
hl.bind(key(mod, "SHIFT", "E"), hl.dsp.exec_cmd(browser .. " --app=https://mail.google.com"), { description = "Email" })
hl.bind(key(mod, "SHIFT", "F"), hl.dsp.exec_cmd(filemanager), { description = "File manager" })
hl.bind(key(mod, "SHIFT", "G"), hl.dsp.exec_cmd(browser .. " --app=https://github.com"), { description = "GitHub" })
hl.bind(key(mod, "SHIFT", "M"), hl.dsp.exec_cmd(browser .. " --app=https://messages.google.com/web/conversations"),
  { description = "Google Messages" })
hl.bind(key(mod, "SHIFT", "N"), hl.dsp.exec_cmd(terminal .. " nvim"), { description = "Neovim" })
hl.bind(key(mod, "SHIFT", "R"), hl.dsp.exec_cmd(browser .. " --app=https://reddit.com"), { description = "Reddit" })
hl.bind(key(mod, "SHIFT", "S"), hl.dsp.exec_cmd(browser .. " --app=https://bsky.app"), { description = "Bluesky" })
hl.bind(key(mod, "SHIFT", "T"),
  hl.dsp.exec_cmd(terminal .. " btop", { float = true, size = { 1200, 800 }, center = true }),
  { description = "System monitor (btop)" })
hl.bind(key(mod, "SHIFT", "U"),
  hl.dsp.exec_cmd(terminal .. " -o font_size=9 yay -Syu", { float = true, size = { 900, 600 }, center = true }),
  { description = "Update system" })
hl.bind(key(mod, "SHIFT", "W"), hl.dsp.exec_cmd(browser), { description = "Browser" })
hl.bind(key(mod, "SHIFT", "Y"), hl.dsp.exec_cmd(browser .. " --app=https://youtube.com"), { description = "YouTube" })
hl.bind(key(mod, "SHIFT", "Z"),
  hl.dsp.exec_cmd(browser .. " --app=https://mantis.chainlogic.it/my_view_page.php?refresh=true"),
  { description = "Mantis" })

-- -----------------------------------------------------------------------------
-- Window Management
-- -----------------------------------------------------------------------------

hl.bind(key(mod, "Q"), hl.dsp.window.close(), { description = "Close window" })
hl.bind(key(mod, "SHIFT", "Q"), hl.dsp.exit(), { description = "Exit Hyprland" })
hl.bind(key(mod, "F"), hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
  { description = "Fullscreen" })
hl.bind(key(mod, "M"), hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Maximize" })
hl.bind(key(mod, "T"), hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(key(mod, "O"), hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(key(mod, "B"), hl.dsp.exec_cmd("killall -SIGUSR1 waybar"), { description = "Toggle waybar" })

-- Focus (vim keys) — unified nav: terminals get ctrl+hjkl injected (driving the
-- neovim/tmux chain, escalating back out at the edge); other windows move focus.
hl.bind(key(mod, "H"), hl.dsp.exec_cmd(hypr_scripts .. "/nav l h"), { description = "Focus/nav left" })
hl.bind(key(mod, "L"), hl.dsp.exec_cmd(hypr_scripts .. "/nav r l"), { description = "Focus/nav right" })
hl.bind(key(mod, "K"), hl.dsp.exec_cmd(hypr_scripts .. "/nav u k"), { description = "Focus/nav up" })
hl.bind(key(mod, "J"), hl.dsp.exec_cmd(hypr_scripts .. "/nav d j"), { description = "Focus/nav down" })

-- Focus last window (alt-tab between two windows)
hl.bind(key(mod, "Tab"), hl.dsp.focus({ last = true }), { description = "Focus last window" })

-- Move windows (vim keys)
hl.bind(key(mod, "SHIFT", "H"), hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind(key(mod, "SHIFT", "L"), hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind(key(mod, "SHIFT", "K"), hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind(key(mod, "SHIFT", "J"), hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })

-- Resize hold -/+ (code:20 = `-`, code:21 = `=`/`+`)
hl.bind(key(mod, "code:20"), hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true })
hl.bind(key(mod, "code:21"), hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true })
hl.bind(key(mod, "SHIFT", "code:20"), hl.dsp.window.resize({ x = 0, y = -25, relative = true }), { repeating = true })
hl.bind(key(mod, "SHIFT", "code:21"), hl.dsp.window.resize({ x = 0, y = 25, relative = true }), { repeating = true })

-- Resize submap
hl.bind(key(mod, "R"), hl.dsp.submap("resize"), { description = "Resize mode" })
hl.define_submap("resize", function()
  hl.bind("H", hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true })
  hl.bind("L", hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true })
  hl.bind("K", hl.dsp.window.resize({ x = 0, y = -25, relative = true }), { repeating = true })
  hl.bind("J", hl.dsp.window.resize({ x = 0, y = 25, relative = true }), { repeating = true })
  hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- -----------------------------------------------------------------------------
-- Workspaces
-- -----------------------------------------------------------------------------

for i = 1, 9 do
  hl.bind(key(mod, i), hl.dsp.focus({ workspace = i }), { description = "Workspace " .. i })
  hl.bind(key(mod, "SHIFT", i), hl.dsp.window.move({ workspace = i, follow = false }),
    { description = "Move window to workspace " .. i })
end
hl.bind(key(mod, 0), hl.dsp.focus({ workspace = 10 }), { description = "Workspace 10" })
hl.bind(key(mod, "SHIFT", 0), hl.dsp.window.move({ workspace = 10, follow = false }),
  { description = "Move window to workspace 10" })

-- Special workspace (scratchpad)
hl.bind(key(mod, "Home"), hl.dsp.workspace.toggle_special("magic"), { description = "Toggle scratchpad" })
hl.bind(key(mod, "Insert"), hl.dsp.window.move({ workspace = "special:magic" }), { description = "Move to scratchpad" })
hl.bind(key(mod, "Delete"), hl.dsp.window.move({ workspace = "e+0" }), { description = "Remove from scratchpad" })

-- -----------------------------------------------------------------------------
-- Grouped Windows (Tabs)
-- -----------------------------------------------------------------------------

hl.bind(key(mod, "G"), hl.dsp.group.toggle(), { description = "Toggle group" })
hl.bind(key(mod, "D"), hl.dsp.window.move({ out_of_group = true }), { description = "Move out of group" })
hl.bind(key(mod, "bracketleft"), hl.dsp.group.prev(), { description = "Previous group tab" })
hl.bind(key(mod, "bracketright"), hl.dsp.group.next(), { description = "Next group tab" })
hl.bind(key(mod, "CTRL", "H"), hl.dsp.window.move({ into_group = "l" }), { description = "Group left" })
hl.bind(key(mod, "CTRL", "L"), hl.dsp.window.move({ into_group = "r" }), { description = "Group right" })
hl.bind(key(mod, "CTRL", "K"), hl.dsp.window.move({ into_group = "u" }), { description = "Group up" })
hl.bind(key(mod, "CTRL", "J"), hl.dsp.window.move({ into_group = "d" }), { description = "Group down" })
hl.bind(key(mod, "ALT", "G"), hl.dsp.group.lock_active({ action = "toggle" }), { description = "Lock group" })

-- -----------------------------------------------------------------------------
-- Mouse bindings
-- -----------------------------------------------------------------------------

hl.bind(key(mod, "mouse:272"), hl.dsp.window.drag(), { mouse = true })
hl.bind(key(mod, "mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- -----------------------------------------------------------------------------
-- Clipboard / Color picker
-- -----------------------------------------------------------------------------

hl.bind(key(mod, "V"), hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"),
  { description = "Clipboard history" })
hl.bind(key(mod, "C"), hl.dsp.exec_cmd("sh -c 'pgrep -x hyprpicker >/dev/null || hyprpicker -r'"),
  { description = "Color picker" })

-- -----------------------------------------------------------------------------
-- Screenshots
-- -----------------------------------------------------------------------------

hl.bind("Print", hl.dsp.exec_cmd(hypr_scripts .. "/screenshot-region"), { description = "Screenshot region" })
hl.bind(key(mod, "Print"), hl.dsp.exec_cmd(hypr_scripts .. "/screenshot"), { description = "Screenshot full" })

-- -----------------------------------------------------------------------------
-- Screen recording
-- -----------------------------------------------------------------------------

hl.bind(key(mod, "ALT", "R"), hl.dsp.exec_cmd(hypr_scripts .. "/screenrecord-region"),
  { description = "Record selected region (toggle)" })
hl.bind(key(mod, "CTRL", "R"), hl.dsp.exec_cmd("killall -s SIGINT wl-screenrec"), { description = "Stop recording" })

-- -----------------------------------------------------------------------------
-- Media / Hardware keys
-- -----------------------------------------------------------------------------

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { repeating = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))

-- -----------------------------------------------------------------------------
-- Lock
-- -----------------------------------------------------------------------------

hl.bind(key("CTRL", "ALT", "L"), hl.dsp.exec_cmd("hyprlock"), { description = "Lock screen" })

-- -----------------------------------------------------------------------------
-- Notifications
-- -----------------------------------------------------------------------------

hl.bind(key(mod, "period"), hl.dsp.exec_cmd("makoctl restore"), { description = "Restore notification" })
hl.bind(key(mod, "comma"), hl.dsp.exec_cmd("makoctl dismiss"), { description = "Dismiss notification" })
hl.bind(key(mod, "SHIFT", "comma"), hl.dsp.exec_cmd("makoctl dismiss --all"),
  { description = "Dismiss all notifications" })
