-- STIMPACK.NVIM
-- A simple vim.pack wrapper

local M = {}

M.config = {}

local spec_util = require("stimpack.spec")
local loader = require("stimpack.loader")
local commands = require("stimpack.commands")
local build = require("stimpack.build")

local function _defaults()
  return require("stimpack.defaults").get()
end

local function _spec_name(spec)
  if type(spec) == "string" then
    return spec_util.get_name(spec)
  end
  if type(spec) ~= "table" then
    return nil
  end
  if spec.name then
    return spec.name
  end
  if spec.dir then
    return spec.name or spec.dir
  end
  if type(spec[1]) == "string" then
    return spec_util.get_name(spec[1])
  end
  return nil
end

function M.setup(opts)
  if vim.fn.has("nvim-0.12") == 0 then
    return
  end

  local start_time = vim.uv.hrtime()
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", _defaults(), opts)
  M.config.plugin_load_times = {}
  M.config.ui_ready_time_ms = nil

  local specs = spec_util.load_all(M.config.paths.plugins, "plugins")

  if M.config.additional_specs then
    for _, loader_fn in ipairs(M.config.additional_specs) do
      local extra_specs = loader_fn()
      if extra_specs then
        for _, extra_spec in ipairs(extra_specs) do
          table.insert(specs, extra_spec)
        end
      end
    end
  end

  local default_priority = 50
  table.sort(specs, function(a, b)
    return (a.priority or default_priority) > (b.priority or default_priority)
  end)

  M.config.specs = spec_util.flatten_specs(specs)
  loader.load_plugins(M, M.config.specs)
  commands.setup(M)
  local end_time = vim.uv.hrtime()
  M.config.startup_time_ms = (end_time - start_time) / 1e6
  M.config.loaded_plugins = #M.config.specs

  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      local ui_ready_end_time = vim.fn.reltime()
      M.config.ui_ready_time_ms =
        vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time, ui_ready_end_time)) * 1000
    end,
  })
end

function M.get_stats()
  local loaded_plugins = vim.pack.get() or {}
  local local_plugins = 0
  for _, spec in ipairs(M.config.specs) do
    if type(spec) == "table" and spec.dir then
      local_plugins = local_plugins + 1
    end
  end
  return {
    startup_time_ms = M.config.startup_time_ms,
    loaded_plugins = #loaded_plugins + local_plugins,
    plugin_load_times = M.config.plugin_load_times,
    ui_ready_time_ms = M.config.ui_ready_time_ms,
  }
end

function M.sync(opts)
  opts = opts or {}
  M.clean({ force = opts.force })
  vim.pack.update()
end

function M.delete(name)
  vim.pack.del({ name })
  vim.notify(("STIMPACK: Successfully deleted %s!"):format(name), vim.log.levels.INFO)
end

function M.update(name, opts)
  vim.pack.update({ name }, opts)
end

function M.get(name)
  local info_list = vim.pack.get({ name }, { info = true })
  if not info_list or #info_list == 0 then
    vim.notify("STIMPACK: Plugin not found: " .. name, vim.log.levels.WARN)
    return
  end

  local info = info_list[1]
  local msg = {
    "Plugin Info: " .. name,
    "Path: " .. (info.path or "N/A"),
    "Active: " .. tostring(info.active),
    "Revision: " .. (info.rev or "N/A"),
  }

  if info.branches then
    table.insert(msg, "Branches: " .. table.concat(info.branches, ", "))
  end

  if info.tags then
    table.insert(msg, "Tags: " .. table.concat(info.tags, ", "))
  end

  vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO)
end

function M.nuke()
  local choice = vim.fn.confirm("☢️ This will DELETE all Neovim plugins on disk.\nAre you sure?", "&Yes\n&No", 2)
  if choice ~= 1 then
    vim.notify("STIMPACK: Aborted. Plugins live another day.", vim.log.levels.INFO)
    return
  end

  local pack_dir = vim.fn.stdpath("data") .. "/site/pack"
  vim.fn.delete(pack_dir, "rf")
  vim.notify("STIMPACK: All plugins have been nuked! Please restart Neovim.", vim.log.levels.INFO)
  local ok = pcall(vim.cmd, "restart")
  if not ok then
    vim.notify("STIMPACK: :restart unavailable — run :qa and relaunch.", vim.log.levels.WARN)
  end
end

function M.clean(opts)
  opts = opts or {}
  local installed_plugins_on_disk = {}
  local pack_root = vim.fn.stdpath("data") .. "/site/pack"
  local pack_dir = pack_root .. "/*/" .. "opt"
  for _, plugin_dir in ipairs(vim.fn.glob(pack_dir .. "/*", 1, 1)) do
    local plugin_name = vim.fn.fnamemodify(plugin_dir, ":t")
    installed_plugins_on_disk[plugin_name] = true
  end

  local spec_plugins_set = {}
  for _, spec in ipairs(M.config.specs) do
    if not (type(spec) == "table" and spec.dir) and (type(spec) ~= "table" or spec.install ~= false) then
      local name = _spec_name(spec)
      if name then
        spec_plugins_set[name] = true
      end
    end

    if type(spec) == "table" and spec.dependencies then
      local deps = spec_util.flatten_specs(spec.dependencies)
      for _, dependency in ipairs(deps) do
        if not (type(dependency) == "table" and dependency.dir)
            and (type(dependency) ~= "table" or dependency.install ~= false)
        then
          local dep_name = _spec_name(dependency)
          if dep_name then
            spec_plugins_set[dep_name] = true
          end
        end
      end
    end
  end

  local orphans = {}
  for name, _ in pairs(installed_plugins_on_disk) do
    if not spec_plugins_set[name] then
      table.insert(orphans, name)
    end
  end

  if #orphans == 0 then
    vim.notify("STIMPACK: No orphaned plugins to clean.", vim.log.levels.INFO)
    return
  end

  if not opts.force then
    local choice = vim.fn.confirm(
      "The following orphaned plugins will be deleted:\n" .. table.concat(orphans, "\n") .. "\n\nAre you sure?",
      "&Yes\n&No",
      2
    )
    if choice ~= 1 then
      vim.notify("STIMPACK: Aborted. Orphaned plugins were not deleted.", vim.log.levels.INFO)
      return
    end
  end

  for _, orphan in ipairs(orphans) do
    M.delete(orphan)
  end

  vim.notify("STIMPACK: Finished cleaning " .. #orphans .. " orphaned plugins.", vim.log.levels.INFO)
end

function M.find_spec(name)
  for _, spec in ipairs(M.config.specs or {}) do
    if _spec_name(spec) == name then
      return spec
    end
  end
  return nil
end

function M.very_lazy()
  vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
end

vim.api.nvim_create_autocmd({
  "CursorMoved",
  "InsertEnter",
  "CmdlineEnter",
}, {
  once = true,
  callback = M.very_lazy,
})

local function hooks(ev)
  local name = ev.data and ev.data.spec and ev.data.spec.name
  local kind = ev.data and ev.data.kind
  if not name or not kind then
    return
  end
  if kind ~= "install" and kind ~= "update" then
    return
  end

  local spec = M.find_spec(name)
  if not spec or type(spec) ~= "table" or not spec.build then
    return
  end

  if not ev.data.active then
    pcall(vim.cmd.packadd, name)
  end
  build.run(spec, name)
end

if vim.fn.has("nvim-0.12") == 1 then
  vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })
end

return M
