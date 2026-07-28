-- Clamshell mode
--
-- The laptop panel is disabled only while the lid is shut AND a real external
-- monitor is present. Every other combination re-enables it, so Hyprland is
-- never left with zero outputs -- undocking with the lid down used to strand the
-- session with eDP-1 disabled and nothing able to bring it back.
--
-- This runs in-process on purpose. Driving it from a shell script via
-- `hyprctl eval 'hl.monitor(...)'` does not work: hl.monitor *accumulates*
-- configurations rather than replacing them, so repeated enable/disable calls
-- desync Hyprland's monitor state from DRM and the re-enable becomes a silent
-- no-op (returns "ok", changes nothing).
--
-- A disabled monitor is removed from the layout, so hl.get_monitor(PANEL) == nil
-- is the honest "is the panel off" check. `hyprctl monitors` is not: it happily
-- reports the panel as enabled, with an active workspace, while it is dark.

local PANEL = "eDP-1"

-- Must match the panel's rule in monitors.lua.
local PANEL_RULE = {
    output   = PANEL,
    mode     = "1920x1200@60",
    position = "0x1080",
    scale    = 1,
    disabled = false, -- explicit: omitting it leaves the panel disabled
}

local function lid_closed()
    local f = io.open("/proc/acpi/button/lid/LID/state", "r")
    if not f then return false end
    local state = f:read("*a") or ""
    f:close()
    return state:match("closed") ~= nil
end

-- Is a real external monitor attached? `skip` excludes one that is being
-- removed but may still be listed while its event is handled.
--
-- When the last real output goes, Hyprland substitutes a placeholder output
-- named FALLBACK. It is not a monitor you can see, so it must not count as an
-- external -- otherwise undocking with the lid shut looks like "still docked"
-- and we disable the panel instead of bringing it back.
local function external_present(skip)
    for _, m in ipairs(hl.get_monitors()) do
        if m.name ~= PANEL and m.name ~= "FALLBACK" and m.name ~= skip then
            return true
        end
    end
    return false
end

-- Hyprland <= 0.55.x cannot enable a monitor when no active monitor remains:
-- hl.monitor() is accepted and silently ignored, leaving FALLBACK as the only
-- output and the panel dark forever. Upstream fix (PR #14547) landed for 0.56;
-- until then a full config reload is the only way out. A plain `hyprctl reload`
-- is not enough: Lua caches required submodules, so it re-reads hyprland.lua
-- but does NOT re-execute monitors.lua's hl.monitor(...) calls. Force that with
-- package.loaded[...] = nil before requiring it again.
--
-- Drop stuck_at_zero_monitors, and its branch below, once we are on 0.56+.
local last_reload = 0

local function stuck_at_zero_monitors(skip)
    return hl.get_monitor(PANEL) == nil and not external_present(skip)
end

-- Reconcile the panel against lid + external state. `closed` overrides the lid
-- reading, since the switch binds know it before /proc catches up.
local function sync(closed, skip)
    if closed == nil then closed = lid_closed() end

    if closed and external_present(skip) then
        hl.monitor({ output = PANEL, disabled = true })
    elseif stuck_at_zero_monitors(skip) then
        -- Debounced: if a reload somehow does not bring the panel back, don't
        -- sit in a reload loop.
        if os.time() - last_reload > 5 then
            last_reload = os.time()
            hl.exec_cmd('hyprctl eval \'package.loaded["monitors"] = nil; require("monitors")\'')
        end
    else
        hl.monitor(PANEL_RULE)
    end
end

-- Undocking with the lid shut means "packing up": suspend. Wait until the panel
-- is genuinely back first, or the machine goes down mid modeset and resume is
-- black. Decide from live state, not a saved flag: the reload in sync() re-runs
-- this whole file, which would reset any module-local flag.
local function suspend_if_packing_up(skip)
    if lid_closed() and not external_present(skip) and hl.get_monitor(PANEL) then
        hl.exec_cmd("systemctl suspend")
    end
end

-- logind's lid handling is inhibited (see autostart.lua), so closing the lid
-- with no external monitor is ours to act on: a plain "shut the laptop" -> sleep.
hl.bind("switch:on:Lid Switch", function()
    sync(true)
    if not external_present() then
        hl.exec_cmd("systemctl suspend")
    end
end, { locked = true })

hl.bind("switch:off:Lid Switch", function() sync(false) end, { locked = true })

hl.on("monitor.added", function(m)
    -- The panel coming back on its own means we just recovered from an undock.
    if m.name == PANEL then
        suspend_if_packing_up()
        return
    end
    sync()
end)

hl.on("monitor.removed", function(m)
    if m.name == PANEL then return end

    -- Bring the panel back, so we are never left with no usable output.
    sync(nil, m.name)

    -- If it was already on, no monitor.added is coming to trigger the suspend.
    suspend_if_packing_up(m.name)
end)

-- A reload only re-runs monitors.lua on the very first load (require() caches
-- it after that), but if it does run it switches the panel back on regardless
-- of the lid. Reconcile, or a reload while docked and shut leaves it lit.
hl.on("config.reloaded", function() sync() end)
