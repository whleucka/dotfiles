-- Clamshell mode
--
-- The laptop panel is disabled only while the lid is shut AND an external
-- monitor is present. Every other combination re-enables it, so Hyprland can
-- never be left with zero outputs -- undocking with the lid down used to strand
-- the session with eDP-1 disabled and nothing able to bring it back.
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
    position = "1920x0",
    scale    = 1,
    disabled = false, -- explicit: omitting it leaves the panel disabled
}

-- TEMPORARY: diagnostic trace, remove once the undock path is confirmed good.
local function trace(what)
    local f = io.open(os.getenv("HOME") .. "/.cache/clamshell.log", "a")
    if not f then return end

    local names = {}
    for _, m in ipairs(hl.get_monitors()) do
        names[#names + 1] = m.name
    end

    f:write(string.format(
        "%s  %-22s monitors=[%s]  panel=%s\n",
        os.date("%H:%M:%S"), what,
        table.concat(names, ", "),
        hl.get_monitor(PANEL) and "on" or "OFF"
    ))
    f:close()
end

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
-- until then a full config reload is the only way out, since it re-applies
-- monitors.lua from scratch instead of diffing against the stuck state.
--
-- Drop this, and the reload branch below, once we are on Hyprland 0.56+.
local last_reload = 0

local function stuck_at_zero_monitors(skip)
    return hl.get_monitor(PANEL) == nil and not external_present(skip)
end

-- Reconcile the panel against lid + external state. `closed` overrides the lid
-- reading, since the switch binds know it before /proc catches up.
local function sync(closed, skip)
    if closed == nil then closed = lid_closed() end

    local want_off = closed and external_present(skip)
    trace(string.format("sync closed=%s -> %s", tostring(closed), want_off and "disable" or "enable"))

    if want_off then
        hl.monitor({ output = PANEL, disabled = true })
    elseif stuck_at_zero_monitors(skip) then
        -- Debounced: if a reload somehow does not bring the panel back, do not
        -- sit in a reload loop.
        if os.time() - last_reload > 5 then
            last_reload = os.time()
            trace("zero monitors -> hyprctl reload")
            hl.exec_cmd("hyprctl reload")
        end
    else
        hl.monitor(PANEL_RULE)
    end

    trace("sync done")
end

-- logind's lid handling is inhibited (see autostart.lua), so closing the lid
-- with no external monitor is ours to act on: that is a plain "shut the laptop"
-- and should suspend.
hl.bind("switch:on:Lid Switch", function()
    sync(true)
    if not external_present() then
        trace("lid shut, no external -> suspending")
        hl.exec_cmd("systemctl suspend")
    end
end, { locked = true })

hl.bind("switch:off:Lid Switch", function() sync(false) end, { locked = true })

-- Undocking with the lid shut means "packing up": suspend. Wait until the panel
-- is genuinely back before doing so, or the machine goes down mid modeset and
-- resume is black. The panel coming back while the lid is shut and nothing is
-- docked *is* that situation, so decide from state rather than a flag set in
-- monitor.removed: the reload above re-executes this file, which would reset it.
local function suspend_if_packing_up(skip)
    if lid_closed() and not external_present(skip) and hl.get_monitor(PANEL) then
        trace("lid shut, undocked, panel on -> suspending")
        hl.exec_cmd("systemctl suspend")
    end
end

hl.on("monitor.added", function(m)
    trace("event added " .. m.name)

    -- The panel coming back on its own means we just recovered from an undock.
    if m.name == PANEL then
        suspend_if_packing_up()
        return
    end
    sync()
end)

hl.on("monitor.removed", function(m)
    trace("event removed " .. m.name)
    if m.name == PANEL then return end

    -- Bring the panel back, so we are never left with no usable output.
    sync(nil, m.name)

    -- If it was already on, no monitor.added is coming to trigger the suspend.
    suspend_if_packing_up(m.name)
end)

-- A reload re-applies monitors.lua, which switches the panel back on regardless
-- of the lid. Reconcile, or a reload while docked and shut leaves it lit.
hl.on("config.reloaded", function()
    trace("event config.reloaded")
    sync()
end)
