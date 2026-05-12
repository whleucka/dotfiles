---@meta
-- Type stubs for the `hl` global exposed by Hyprland 0.55+ Lua configs.
-- See https://wiki.hypr.land/Configuring/ for full docs.

---@class hl.RuleHandle
---@field set_enabled fun(self: hl.RuleHandle, enabled: boolean)
---@field is_enabled fun(self: hl.RuleHandle): boolean

---@class hl.BindHandle
---@field set_enabled fun(self: hl.BindHandle, enabled: boolean)

---@class hl.Dispatcher

---@class hl.BindFlags
---@field description? string
---@field repeating? boolean
---@field locked? boolean
---@field release? boolean
---@field long_press? boolean
---@field mouse? boolean
---@field non_consuming? boolean
---@field auto_consuming? boolean
---@field transparent? boolean
---@field ignore_mods? boolean
---@field separate? boolean
---@field bypass? boolean
---@field submap_universal? boolean
---@field click? boolean
---@field drag? boolean
---@field devices? table

---@class hl.dsp.window
---@field close fun(window?: any): hl.Dispatcher
---@field kill fun(window?: any): hl.Dispatcher
---@field signal fun(opts: { signal: integer, window?: any }): hl.Dispatcher
---@field float fun(opts: { action?: "toggle"|"enable"|"on"|"disable"|"off", window?: any }): hl.Dispatcher
---@field fullscreen fun(opts: { mode?: "fullscreen"|"maximized", action?: "toggle"|"set"|"unset", window?: any }): hl.Dispatcher
---@field fullscreen_state fun(opts: { internal: integer, client: integer, action?: string, window?: any }): hl.Dispatcher
---@field pseudo fun(opts?: { action?: string, window?: any }): hl.Dispatcher
---@field move fun(opts: table): hl.Dispatcher
---@field swap fun(opts: table): hl.Dispatcher
---@field center fun(opts?: { window?: any }): hl.Dispatcher
---@field cycle_next fun(opts?: table): hl.Dispatcher
---@field tag fun(opts: { tag: string, window?: any }): hl.Dispatcher
---@field clear_tags fun(opts?: { window?: any }): hl.Dispatcher
---@field toggle_swallow fun(): hl.Dispatcher
---@field pin fun(opts?: { window?: any }): hl.Dispatcher
---@field alter_zorder fun(opts: { mode: "top"|"bottom", window?: any }): hl.Dispatcher
---@field set_prop fun(opts: { prop: string, value: any, window?: any }): hl.Dispatcher
---@field deny_from_group fun(opts?: { action?: string }): hl.Dispatcher
---@field drag fun(): hl.Dispatcher
---@field resize fun(opts?: { x: number, y: number, relative?: boolean, window?: any }): hl.Dispatcher

---@class hl.dsp.workspace
---@field rename fun(opts: { workspace: any, name?: string }): hl.Dispatcher
---@field move fun(opts: { workspace?: any, monitor: any }): hl.Dispatcher
---@field swap_monitors fun(opts: { monitor1: any, monitor2: any }): hl.Dispatcher
---@field toggle_special fun(name?: string): hl.Dispatcher

---@class hl.dsp.group
---@field toggle fun(opts?: { window?: any }): hl.Dispatcher
---@field next fun(opts?: { window?: any }): hl.Dispatcher
---@field prev fun(opts?: { window?: any }): hl.Dispatcher
---@field active fun(opts: { index: integer, window?: any }): hl.Dispatcher
---@field move_window fun(opts: { forward?: boolean, window?: any }): hl.Dispatcher
---@field lock fun(opts?: { action?: string, window?: any }): hl.Dispatcher
---@field lock_active fun(opts?: { action?: string }): hl.Dispatcher

---@class hl.dsp.cursor
---@field move_to_corner fun(opts: { corner: integer, window?: any }): hl.Dispatcher
---@field move fun(opts: { x: number, y: number }): hl.Dispatcher

---@class hl.dsp
---@field exec_cmd fun(cmd: string, rules?: table): hl.Dispatcher
---@field exec_raw fun(cmd: string): hl.Dispatcher
---@field focus fun(opts: table): hl.Dispatcher
---@field exit fun(): hl.Dispatcher
---@field submap fun(name: string): hl.Dispatcher
---@field pass fun(opts: any): hl.Dispatcher
---@field send_shortcut fun(opts: { mods: string, key: string, window?: any }): hl.Dispatcher
---@field send_key_state fun(opts: { mods: string, key: string, state: string, window?: any }): hl.Dispatcher
---@field layout fun(message: string): hl.Dispatcher
---@field dpms fun(opts?: { action?: string, monitor?: any }): hl.Dispatcher
---@field event fun(s: string): hl.Dispatcher
---@field global fun(s: string): hl.Dispatcher
---@field force_idle fun(seconds: number): hl.Dispatcher
---@field no_op fun(): hl.Dispatcher
---@field window hl.dsp.window
---@field workspace hl.dsp.workspace
---@field group hl.dsp.group
---@field cursor hl.dsp.cursor

---@class hl
---@field dsp hl.dsp
hl = {}

--- Set Hyprland config keywords (general, decoration, input, animations, etc.).
---@param cfg table
function hl.config(cfg) end

--- Set an environment variable for Hyprland-launched processes.
---@param name string
---@param value string
function hl.env(name, value) end

--- Configure a monitor.
---@param opts table
function hl.monitor(opts) end

--- Define a gesture.
---@param opts { fingers: integer, direction: string, action: string }
function hl.gesture(opts) end

--- Per-device config (e.g. mouse sensitivity).
---@param opts table
function hl.device(opts) end

--- Define a named bezier or spring curve for animations.
---@param name string
---@param opts table
function hl.curve(name, opts) end

--- Configure an animation leaf.
---@param opts table
function hl.animation(opts) end

--- Define a window rule. Returns a handle for named rules.
---@param rule table
---@return hl.RuleHandle?
function hl.window_rule(rule) end

--- Define a workspace rule.
---@param rule table
function hl.workspace_rule(rule) end

--- Define a layer rule.
---@param rule table
---@return hl.RuleHandle?
function hl.layer_rule(rule) end

--- Bind a key/key combo to a dispatcher (or a Lua function).
---@param keys string
---@param dispatcher hl.Dispatcher|fun()
---@param flags? hl.BindFlags
---@return hl.BindHandle
function hl.bind(keys, dispatcher, flags) end

--- Define a submap. The function body contains the binds active in the submap.
---@param name string
---@param body_or_next fun()|string
---@param body? fun()
function hl.define_submap(name, body_or_next, body) end

--- Subscribe to a Hyprland event (e.g. "hyprland.start", "hyprland.shutdown").
---@param event string
---@param handler fun()
function hl.on(event, handler) end

--- Execute a shell command asynchronously (via `bash -c`).
---@param cmd string
function hl.exec_cmd(cmd) end

--- Execute a raw command (no shell).
---@param cmd string
function hl.exec_raw(cmd) end

--- Execute a dispatcher imperatively (e.g. inside a Lua function bind).
---@param dispatcher hl.Dispatcher
function hl.dispatch(dispatcher) end

--- Configure runtime permissions (must be at top of config; not hot-reloadable).
---@param exe_pattern string
---@param permission string
---@param action "allow"|"deny"|"ask"
function hl.permission(exe_pattern, permission, action) end

--- Create a timer (one-shot or repeating).
---@param fn fun()
---@param opts { timeout: integer, type?: "oneshot"|"repeat" }
function hl.timer(fn, opts) end
