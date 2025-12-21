-- STIMPACK.NVIM
-- A simple vim.pack wrapper

local M = {}

M.config = {}

local function _safe_require(mod)
  local ok, result = pcall(require, mod)
  if not ok then
    -- plugin failed to load
    vim.notify(
      ("Failed loading %s\n%s"):format(mod, result),
      vim.log.levels.WARN
    )
    return nil
  end
  return result
end

local function _load_specs(dir)
  local specs = {}
  for name, type in vim.fs.dir(dir) do
    -- get all the lua files in the plugin dir
    if type == "file" and name:sub(-4) == ".lua" then
      -- strip off .lua
      local basename = name:gsub("%.lua$", "")
      local spec = _safe_require("plugins." .. basename)
      if spec then
        -- add spec to specs
        table.insert(specs, spec)
      end
    end
  end
  -- higher priority plugins should load first
  local default_priority = 50
  table.sort(specs, function(a, b)
    return (a.priority or default_priority) > (b.priority or default_priority)
  end)
  return specs
end

local function _get_source(spec)
  local source
  if type(spec) == "string" then
    source = spec
  else
    source = spec[1]
  end

  if not string.find(source, "^http") then
    -- ensure a slash between github base and path
    if source:sub(1, 1) ~= "/" then
      source = "/" .. source
    end
    -- assume github url?
    source = "https://github.com" .. source
  end
  return source
end

local function _get_name(source)
  local name = source:match(".*/(.*)")
  if name and name:sub(-4) == ".git" then
    name = name:sub(1, -5)
  end
  return name or source
end

local function _pack_spec(spec, lazy)
  -- the goal is the mimic the vim.pack plugin spec
  -- see https://neovim.io/doc/user/pack.html
  local pack = {}
  local source = _get_source(spec)
  pack.src = source

  if type(spec) == "table" then
    pack.name = spec.name or _get_name(source)
    if spec.version then
      pack.version = spec.version
    end
    if spec.build then
      pack.build = spec.build
    end
    if spec.data then
      pack.data = spec.data
    end
  else
    pack.name = _get_name(source)
  end

  if lazy then
    pack.opt = true
  end

  return pack
end

local function _load_plugin(pack)
  vim.pack.add({ pack })
end

local function _run_config(config)
  if type(config) == "function" then
    local ok, err = pcall(config)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end

local function _in_table(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

local function _normalize_event(event)
  if not event then
    return {}
  end

  if type(event) == "string" then
    return { event }
  end

  if type(event) == "table" then
    return event
  end

  error("event must be a string or table of strings")
end

local function _run_build(spec, pack_name, force)
  if not spec.build then
    return
  end

  local info_list = vim.pack.get({ pack_name }, { info = true })
  if not info_list or #info_list == 0 or not info_list[1].path then
    vim.notify("Could not find path for " .. pack_name .. " to run build.", vim.log.levels.WARN)
    return
  end
  local plugin_path = info_list[1].path
  local marker_file = plugin_path .. "/.stimpack_built"

  if not force then
    local f = io.open(marker_file, "r")
    if f then
      f:close()
      return -- build already done
    end
  end

  vim.notify("Building " .. pack_name .. "...", vim.log.levels.INFO)

  local build_cmd = spec.build
  local success = false
  if type(build_cmd) == "string" then
    local result = vim.fn.system("cd " .. vim.fn.shellescape(plugin_path) .. " && " .. build_cmd)
    if vim.v.shell_error == 0 then
      success = true
    else
      vim.notify("Failed to build " .. pack_name .. ":\n" .. result, vim.log.levels.ERROR)
    end
  elseif type(build_cmd) == "function" then
    local ok, err = pcall(build_cmd)
    if ok then
      success = true
    else
      vim.notify("Failed to build " .. pack_name .. ":\n" .. err, vim.log.levels.ERROR)
    end
  end

  if success then
    vim.notify("Successfully built " .. pack_name, vim.log.levels.INFO)
    -- create marker file
    local f = io.open(marker_file, "w")
    if f then
      f:close()
    end
  else
    -- if we forced a build and it failed, remove the marker so we can try again next time
    if force then
      os.remove(marker_file)
    end
  end
end

local function _register_key(spec)
  if spec.keys then
    local keys_table = spec.keys
    if type(keys_table) == "function" then
      keys_table = keys_table()
    end
    local with = require("core.utils").with
    with("which-key", function(m)
      m.add(keys_table)
    end)
  end
end

local function _load_plugins(specs)
  for i, spec in ipairs(specs) do
    local should_load = true
    if spec.enabled ~= nil then
      if type(spec.enabled) == "function" then
        should_load = spec.enabled()
      else
        should_load = spec.enabled
      end
    end

    if should_load then
      local is_lazy = spec.event ~= nil or spec.lazy == true or spec.cmd ~= nil or spec.ft ~= nil
      local dep_names = {}

      -- load dependencies
      if spec.dependencies then
        for i, dependency in ipairs(spec.dependencies) do
          -- dependencies inherit lazy status from parent
          local pack = _pack_spec(dependency, is_lazy)
          _load_plugin(pack)
          if is_lazy then
            table.insert(dep_names, pack.name)
          end
        end
      end

      -- load main spec
      local pack = _pack_spec(spec, is_lazy)
      _load_plugin(pack)

      if is_lazy then
        -- Setup lazy loading
        local loaded = false
        local load_handler = function(args)
          if loaded then
            return
          end
          loaded = true

          -- load dependencies first
          for _, dep_name in ipairs(dep_names) do
            vim.cmd.packadd(dep_name)
          end

          vim.cmd.packadd(pack.name)
          _run_build(spec, pack.name, false)

          if spec.config then
            _run_config(spec.config)
          end

          _register_key(spec)

          -- if invoked via command, we might need to re-run the command?
          -- For simplicity, we assume the user just wanted the plugin loaded.
          -- But for perfect emulation, we should execute the command if args are passed.
        end

        if spec.event then
          local events = _normalize_event(spec.event)
          if _in_table(events, "VeryLazy") then
            vim.api.nvim_create_autocmd("User", {
              once = true,
              pattern = "VeryLazy",
              callback = load_handler,
            })
          else
            vim.api.nvim_create_autocmd(events, {
              once = true,
              callback = load_handler,
            })
          end
        end

        if spec.ft then
          vim.api.nvim_create_autocmd("FileType", {
            pattern = spec.ft,
            once = true,
            callback = load_handler,
          })
        end

        if spec.cmd then
          local cmds = type(spec.cmd) == "table" and spec.cmd or { spec.cmd }
          for _, cmd in ipairs(cmds) do
            vim.api.nvim_create_user_command(cmd, function(cmd_args)
              -- Remove the self-destructing command to avoid infinite loop if the plugin doesn't define it
              vim.api.nvim_del_user_command(cmd)
              load_handler()
              -- Re-execute the command if the plugin defined it, or just let it be
              -- This is tricky because we don't know if the plugin creates the command.
              -- If the plugin creates the command, it might have been created during packadd/config.
              -- We try to execute it.
              local ok, err = pcall(
                vim.cmd,
                { cmd = cmd, args = cmd_args.fargs, bang = cmd_args.bang }
              )
              if not ok then
                -- It's possible the plugin didn't create the command immediately or mapped it differently.
                -- We ignore for now or notify.
              end
            end, { bang = true, nargs = "*", complete = "file" }) -- Generic params
          end
        end
      else
        -- Eager load
        -- Dependencies are already added (assumed eager if parent is eager)
        _run_build(spec, pack.name, false)
        if spec.config then
          _run_config(spec.config)
        end
        _register_key(spec)
      end
    end
  end
end

local function _defaults()
  return require("stimpack.defaults").get()
end

function M.setup(opts)
  opts = opts or {}
  -- warning, config is not validated!
  M.config = vim.tbl_deep_extend("force", _defaults(), opts)
  -- load the specs
  M.config.specs = _load_specs(M.config.paths.plugins)
  -- load the plugins
  _load_plugins(M.config.specs)
end

function M.sync()
  vim.pack.update()
  vim.notify("Plugins updated, running build steps...", vim.log.levels.INFO)
  for _, spec in ipairs(M.config.specs) do
    if spec.build then
      local pack_name = spec.name or _get_name(_get_source(spec))
      _run_build(spec, pack_name, true)
    end
  end
end

function M.delete(name)
  vim.pack.del({ name })
  vim.notify(("✅ Successfully deleted %s!"):format(name), vim.log.levels.INFO)
end

function M.update(name, opts)
  vim.pack.update({ name }, opts)
  for _, spec in ipairs(M.config.specs) do
    local pack_name = spec.name or _get_name(_get_source(spec))
    if pack_name == name and spec.build then
      _run_build(spec, name, true)
      break
    end
  end
end

function M.get(name)
  local info_list = vim.pack.get({ name }, { info = true })
  if not info_list or #info_list == 0 then
    vim.notify("Plugin not found: " .. name, vim.log.levels.WARN)
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
  local choice = vim.fn.confirm(
    "☢️ This will DELETE all Neovim plugins on disk.\nAre you sure?",
    "&Yes\n&No",
    2
  )
  if choice ~= 1 then
    vim.notify("😎 Aborted. Plugins live another day.", vim.log.levels.INFO)
    return
  end

  local pack_dir = vim.fn.stdpath("data") .. "/site/pack"
  vim.fn.delete(pack_dir, "rf")
  vim.notify("✅ All plugins have been nuked! You may now :restart Neovim!", vim.log.levels.INFO)
end

-- cmd updates all plugins
vim.api.nvim_create_user_command("StimSync", M.sync, {})
-- cmd deletes a single plugin
vim.api.nvim_create_user_command("StimDelete", function(args)
  local name = args.fargs[1]
  M.delete(name)
end, {
  nargs = 1,
})
-- cmd updates a single plugin
vim.api.nvim_create_user_command("StimUpdate", function(args)
  local name = args.fargs[1]
  M.update(name, { force = true })
end, {
  nargs = 1,
})
-- cmd gets info for a single plugin
vim.api.nvim_create_user_command("StimGet", function(args)
  local name = args.fargs[1]
  M.get(name)
end, {
  nargs = 1,
})
-- cmd deletes all plugins on disk (be careful y'all!)
vim.api.nvim_create_user_command("StimNuke", function()
  M.nuke()
end, {})

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

return M
