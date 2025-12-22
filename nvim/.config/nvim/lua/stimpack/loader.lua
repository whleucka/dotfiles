-- lua/stimpack/loader.lua
local M = {}

local lazy = require("stimpack.lazy")
local spec_util = require("stimpack.spec")

local function _run_config(config)
  if type(config) == "function" then
    local ok, err = pcall(config)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
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

local function _load_plugin(pack)
  vim.pack.add({ pack })
end

function M.load_plugins(specs)
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
          local pack = spec_util.pack_spec(dependency, is_lazy)
          _load_plugin(pack)
          if is_lazy then
            table.insert(dep_names, pack.name)
          end
        end
      end

      local pack
      local process_plugin = true
      if spec.dir then
        local dir_path = vim.fn.expand(spec.dir)
        if vim.fn.isdirectory(dir_path) == 1 then
          vim.opt.rtp:append(dir_path)
          pack = { name = spec.name or spec.dir }
        else
          process_plugin = false
          local name = spec.name or spec_util.get_name(spec_util.get_source(spec))
          vim.notify(
            ("STIMPACK: Directory not found for plugin '%s': %s"):format(name, spec.dir),
            vim.log.levels.WARN
          )
        end
      else
        pack = spec_util.pack_spec(spec, is_lazy)
        _load_plugin(pack)
      end

      if process_plugin then
        if not spec.config then
          -- If no config, we might auto-generate one from opts, or a default one.
          spec.config = function()
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
              -- if opts or main were given, but we couldn't find setup, it's a problem.
              vim.notify(
                ("STIMPACK: could not auto-setup '%s'. No 'setup' function found for module '%s'.")
                :format(pack.name, module_name),
                vim.log.levels.WARN
              )
            end
          end
        end

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

            if not spec.dir then
              vim.cmd.packadd(pack.name)
            end
  

            if spec.config then
              _run_config(spec.config)
            end

            _register_key(spec)

            -- if invoked via command, we might need to re-run the command?
            -- For simplicity, we assume the user just wanted the plugin loaded.
            -- But for perfect emulation, we should execute the command if args are passed.
          end

          lazy.setup_loading(spec, pack, dep_names, load_handler)
        else
          -- Eager load
          -- Dependencies are already added (assumed eager if parent is eager)

          if spec.config then
            _run_config(spec.config)
          end
          _register_key(spec)
        end
      end
    end
  end
end

return M
