local M = {}

local lazy = require("stimpack.lazy")
local spec_util = require("stimpack.spec")

local function _run_config(config, name)
  if type(config) == "function" then
    local ok, err = pcall(config)
    if not ok then
      vim.notify(
        ("STIMPACK: error running config for '%s': %s"):format(name or "?", err),
        vim.log.levels.ERROR
      )
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

-- Lazy plugins must stay OFF 'runtimepath' until their trigger fires. Anything
-- on 'rtp' when init.lua returns has its plugin/ scripts sourced by Nvim's own
-- startup plugin loading -- that is all `:packadd!` means -- so splicing lazy
-- plugins into 'rtp' up front ran every one of their plugin/ files at startup
-- (~24ms of a ~76ms start), lazy in name only.
--
-- Specs still need to `require` a lazy plugin before it loads (in `keys` or
-- `opts`), so its modules are resolved by a package searcher over each plugin's
-- lua/ dir instead. The real `:packadd` on the trigger puts it on 'rtp' and
-- sources plugin/; after that Nvim's own loader finds its modules first.
-- Top-level module name -> plugin paths. A list, because plugins share
-- namespaces: blink.cmp and blink.lib both ship lua/blink/.
local lazy_modules = {}

local function _index_lua_dir(path)
  local lua_dir = path .. "/lua"
  if not vim.uv.fs_stat(lua_dir) then
    return
  end
  for name, type_ in vim.fs.dir(lua_dir) do
    local mod = type_ == "directory" and name or name:match("^(.+)%.lua$")
    if mod then
      lazy_modules[mod] = lazy_modules[mod] or {}
      table.insert(lazy_modules[mod], path)
    end
  end
end

local function _lazy_searcher(modname)
  local roots = lazy_modules[modname:match("^[^.]+")]
  if not roots then
    return nil
  end
  local rel = modname:gsub("%.", "/")
  for _, root in ipairs(roots) do
    for _, suffix in ipairs({ ".lua", "/init.lua" }) do
      local file = root .. "/lua/" .. rel .. suffix
      if vim.uv.fs_stat(file) then
        return assert(loadfile(file))
      end
    end
  end
  return "\n\tno file in stimpack lazy plugins"
end

local function _register_lazy_paths(paths)
  if #paths == 0 then
    return
  end
  for _, path in ipairs(paths) do
    _index_lua_dir(path)
  end
  -- Last, so the byte-compiled vim.loader / 'rtp' searchers always win once a
  -- plugin has actually been packadd'ed.
  table.insert(package.loaders, _lazy_searcher)
end

-- Collects packs for one batched registration per load mode. A plugin can be
-- named more than once (top-level spec plus another plugin's dependency): the
-- first spec wins (matching vim.pack's own "first one controls the spec" rule,
-- and why specs are priority-sorted), but any eager mention makes it eager.
local function _new_registry()
  local reg = { order = {}, by_name = {} }

  function reg.want(pack, is_lazy)
    local seen = reg.by_name[pack.name]
    if seen then
      seen.is_lazy = seen.is_lazy and is_lazy
      return
    end
    local entry = { pack = pack, is_lazy = is_lazy }
    reg.by_name[pack.name] = entry
    table.insert(reg.order, entry)
  end

  function reg.add_all()
    local eager, lazy = {}, {}
    for _, entry in ipairs(reg.order) do
      table.insert(entry.is_lazy and lazy or eager, entry.pack)
    end
    if #eager > 0 then
      vim.pack.add(eager)
    end
    if #lazy > 0 then
      local paths = {}
      vim.pack.add(lazy, {
        load = function(data)
          paths[#paths + 1] = data.path
        end,
      })
      _register_lazy_paths(paths)
    end
  end

  return reg
end

local function _auto_config(spec, pack)
  return function()
    local module_name
    if spec.main then
      module_name = spec.main
    else
      module_name = pack.name:gsub("[-.]nvim$", "")
    end

    local ok, mod = pcall(require, module_name)
    if ok and mod and type(mod.setup) == "function" then
      local opts_table = spec.opts or {}
      local setup_ok, err = pcall(mod.setup, opts_table)
      if not setup_ok then
        vim.notify(
          ("STIMPACK: error calling setup for '%s': %s"):format(pack.name, err),
          vim.log.levels.ERROR
        )
      end
    elseif spec.opts ~= nil or spec.main then
      vim.notify(
        ("STIMPACK: could not auto-setup '%s'. No 'setup' function found for module '%s'.")
        :format(pack.name, module_name),
        vim.log.levels.WARN
      )
    end
  end
end

function M.load_plugins(stimpack, specs)
  local plugin_load_times = stimpack.config.plugin_load_times

  -- Pass 1: resolve specs and collect packs so all of them can be registered
  -- with vim.pack in one batched call per load mode.
  local entries = {}
  local registry = _new_registry()

  for _, spec in ipairs(specs) do
    local should_load = true
    if spec.enabled ~= nil then
      if type(spec.enabled) == "function" then
        should_load = spec.enabled()
      else
        should_load = spec.enabled
      end
    end

    if should_load then
      local is_lazy = spec.event ~= nil
        or spec.lazy == true
        or spec.cmd ~= nil
        or spec.ft ~= nil
        or spec.keys ~= nil

      local pack
      local process_plugin = true
      if spec.dir then
        local dir_path = vim.fn.expand(spec.dir)
        if vim.fn.isdirectory(dir_path) == 1 then
          vim.opt.rtp:append(dir_path)
          pack = { name = spec.name or spec.dir }
        else
          vim.notify(
            ("STIMPACK: local plugin dir not found: %s"):format(dir_path),
            vim.log.levels.WARN
          )
          process_plugin = false
        end
      else
        pack = spec_util.pack_spec(spec)
      end

      if process_plugin then
        if not spec.dir and spec.install ~= false then
          registry.want(pack, is_lazy)
        end

        local dep_names = {}
        if spec.dependencies then
          for _, dependency in ipairs(spec.dependencies) do
            local dep_pack = spec_util.pack_spec(dependency)
            -- Dependencies inherit the parent's load mode
            registry.want(dep_pack, is_lazy)
            table.insert(dep_names, dep_pack.name)
          end
        end

        if not spec.config then
          spec.config = _auto_config(spec, pack)
        end

        table.insert(entries, {
          spec = spec,
          pack = pack,
          is_lazy = is_lazy,
          dep_names = dep_names,
        })
      end
    end
  end

  registry.add_all()

  -- Pass 2: run configs for eager plugins, register triggers for lazy ones
  for _, entry in ipairs(entries) do
    local spec, pack, dep_names = entry.spec, entry.pack, entry.dep_names

    if entry.is_lazy then
      local loaded = false
      local load_handler = function(_args)
        if loaded then
          return
        end
        loaded = true
        local start_time = vim.uv.hrtime()

        for _, dep_name in ipairs(dep_names) do
          pcall(vim.cmd.packadd, dep_name)
        end

        if not spec.dir then
          pcall(vim.cmd.packadd, pack.name)
        end

        if spec.config then
          _run_config(spec.config, pack.name)
        end

        if spec.keys then
          _register_key(spec)
        end
        local end_time = vim.uv.hrtime()
        plugin_load_times[pack.name] = (end_time - start_time) / 1e6
      end

      lazy.setup_loading(spec, pack, dep_names, load_handler)
    else
      -- eager load — vim.pack.add already handled packadd for parent
      -- and deps, so we just run config + register keys
      local start_time = vim.uv.hrtime()
      if spec.config then
        _run_config(spec.config, pack.name)
      end
      if spec.keys then
        _register_key(spec)
      end
      local end_time = vim.uv.hrtime()
      plugin_load_times[pack.name] = (end_time - start_time) / 1e6
    end
  end
end

return M
