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

local function _pack_spec(spec)
  -- the goal is the mimic the vim.pack plugin spec
  -- see https://neovim.io/doc/user/pack.html
  local pack = {}
  local source = _get_source(spec)
  if type(spec) == "table" then
    pack.src = source
    if spec.name then
      pack.name = spec.name
    end
    if spec.version then
      pack.version = spec.version
    end
    if spec.data then
      pack.data = spec.data
    end
  else
    pack.src = source
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

local function _load_plugins(specs)
  for i, spec in ipairs(specs) do
    -- try to load the dep specs, first
    if spec.dependencies then
      for i, dependency in ipairs(spec.dependencies) do
        local pack = _pack_spec(dependency)
        _load_plugin(pack)
      end
    end

    -- load main spec
    local pack = _pack_spec(spec)
    _load_plugin(pack)

    -- run config
    if spec.config then
      if spec.event then
        event = _normalize_event(spec.event)
        if event and _in_table(event, "VeryLazy") then
            vim.api.nvim_create_autocmd("User", {
              once = true,
              pattern = "VeryLazy",
              callback = function()
                _run_config(spec.config)
              end,
            })
        else
          vim.api.nvim_create_autocmd(spec.event, {
            once = true,
            callback = function()
              _run_config(spec.config)
            end,
          })
        end
      else
        _run_config(spec.config)
      end
    end
  end
end

local function _register_keys(specs)
  for i, spec in ipairs(specs) do
    if spec.keys then
      local with = require("core.utils").with
      with("which-key", function(m)
        m.add(spec.keys)
      end)
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
  -- register keybinds
  _register_keys(M.config.specs)
end

function M.sync()
  vim.pack.update()
  vim.notify("✅ All plugins have been updated successfully!", vim.log.levels.INFO)
end

function M.delete(name)
  vim.pack.del({ name })
  vim.notify(("✅ Successfully deleted %s!"):format(name), vim.log.levels.INFO)
end

function M.update(name, opts)
  vim.pack.update({ name }, opts)
  vim.notify(("✅ Successfully updated %s!"):format(name), vim.log.levels.INFO)
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
-- cmd deletes all plugins on disk (be careful y'all!)
vim.api.nvim_create_user_command("StimNuke", function()
  M.nuke()
end, {})

function M.very_lazy()
  -- trigger the very lazy autocmd
  vim.api.nvim_exec_autocmds("User", {
    pattern = "VeryLazy"
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
