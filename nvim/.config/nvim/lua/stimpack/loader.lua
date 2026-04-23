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

local function _add_pack(pack)
  -- Relies on vim.pack.add's init-time default (load = false, i.e. `:packadd!`)
  -- which puts lua/ on rtp but defers plugin/ and ftdetect/ sourcing. Full
  -- `:packadd` is then triggered on the lazy event for lazy plugins, or
  -- implicitly via VimEnter for eager plugins.
  vim.pack.add({ pack })
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
        if spec.install ~= false then
          _add_pack(pack)
        end
      end

      if process_plugin then
        local dep_names = {}

        if spec.dependencies then
          for _, dependency in ipairs(spec.dependencies) do
            local dep_pack = spec_util.pack_spec(dependency)
            _add_pack(dep_pack)
            table.insert(dep_names, dep_pack.name)
          end
        end

        if not spec.config then
          spec.config = _auto_config(spec, pack)
        end

        if is_lazy then
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
  end
end

return M
