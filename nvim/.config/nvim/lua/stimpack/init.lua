-- STIMPACK.NVIM
-- A simple vim.pack wrapper

local M = {}

M.config = {}

local spec_util = require("stimpack.spec")
local loader = require("stimpack.loader")
local commands = require("stimpack.commands")
local build = require("stimpack.build")

local function flatten_specs(specs)
  local flat_specs = {}
  if not specs then
    return flat_specs
  end
  for _, item in ipairs(specs) do
    if type(item[1]) == "table" then
      local sub_specs = flatten_specs(item)
      for _, sub_item in ipairs(sub_specs) do
        table.insert(flat_specs, sub_item)
      end
    else
      table.insert(flat_specs, item)
    end
  end
  return flat_specs
end

local function _defaults()
  return require("stimpack.defaults").get()
end

function M.setup(opts)
  local start_time = vim.loop.hrtime()
  opts = opts or {}
  -- warning, config is not validated!
  M.config = vim.tbl_deep_extend("force", _defaults(), opts)
  -- load the specs
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

  M.config.specs = flatten_specs(specs)
  -- load the plugins
  loader.load_plugins(M.config.specs)
  -- setup commands
  commands.setup(M)
  local end_time = vim.loop.hrtime()
  M.config.startup_time_ms = (end_time - start_time) / 1e6
  M.config.loaded_plugins = #M.config.specs
end

function M.get_stats()
  return {
    startup_time_ms = M.config.startup_time_ms,
    loaded_plugins = M.config.loaded_plugins,
  }
end

function M.sync()
  M.clean()
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
  vim.notify("STIMPACK: All plugins have been nuked! You may now :restart Neovim!", vim.log.levels.INFO)
end

function M.clean()
  -- 1. Get installed plugins from disk
  local installed_plugins_on_disk = {}
  local pack_root = vim.fn.stdpath("data") .. "/site/pack"
  local pack_dir = pack_root .. "/*/" .. "opt"
  for _, plugin_dir in ipairs(vim.fn.glob(pack_dir .. "/*", 1, 1)) do
    local plugin_name = vim.fn.fnamemodify(plugin_dir, ":t")
    installed_plugins_on_disk[plugin_name] = true
  end

  -- 2. Get spec plugins and their dependencies
  local spec_plugins_set = {}
  for _, spec in ipairs(M.config.specs) do
    if not spec.dir and spec.install ~= false then -- ignore local plugins
      local name = spec.name or spec_util.get_name(spec_util.get_source(spec))
      spec_plugins_set[name] = true
    end

    if spec.dependencies then
      local deps = flatten_specs(spec.dependencies)
      for _, dependency in ipairs(deps) do
        if not (type(dependency) == "table" and dependency.dir) and dependency.install ~= false then
          local dep_name = (type(dependency) == "table" and dependency.name)
            or spec_util.get_name(spec_util.get_source(dependency))
          spec_plugins_set[dep_name] = true
        end
      end
    end
  end

  -- 3. Find orphans
  local orphans = {}
  for name, _ in pairs(installed_plugins_on_disk) do
    if not spec_plugins_set[name] then
      table.insert(orphans, name)
    end
  end

  -- 4. Delete orphans
  if #orphans == 0 then
    vim.notify("STIMPACK: No orphaned plugins to clean.", vim.log.levels.INFO)
    return
  end

  local choice = vim.fn.confirm(
    "The following orphaned plugins will be deleted:\n" .. table.concat(orphans, "\n") .. "\n\nAre you sure?",
    "&Yes\n&No",
    2
  )
  if choice ~= 1 then
    vim.notify("STIMPACK: Aborted. Orphaned plugins were not deleted.", vim.log.levels.INFO)
    return
  end

  for _, orphan in ipairs(orphans) do
    M.delete(orphan)
  end

  vim.notify("STIMPACK: Finished cleaning " .. #orphans .. " orphaned plugins.", vim.log.levels.INFO)
end

function M.very_lazy()
  -- trigger the very lazy autocmd
  vim.api.nvim_exec_autocmds("User", {
    pattern = "VeryLazy",
  })
end

-- similar event to lazy
vim.api.nvim_create_autocmd({
  "CursorMoved",
  "InsertEnter",
  "CmdlineEnter",
}, {
  once = true,
  callback = M.very_lazy,
})

local function hooks(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if kind == "install" or kind == "update" then
    for _, spec in ipairs(M.config.specs) do
      local spec_name = type(spec) == "string" and require("stimpack.spec").get_name(spec)
        or spec.name
        or require("stimpack.spec").get_name(spec[1])
      if spec_name == name then
        if not ev.data.active then
          vim.cmd.packadd(name)
        end
        build.run(spec, name)
        break
      end
    end
  end
end

vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })

return M