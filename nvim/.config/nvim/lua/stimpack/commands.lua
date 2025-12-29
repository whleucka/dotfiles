local M = {}

function M.setup(stimpack)
  -- cmd updates all plugins
  vim.api.nvim_create_user_command("StimSync", function()
    stimpack.sync()
  end, {})
  -- cmd deletes a single plugin
  vim.api.nvim_create_user_command("StimDelete", function(args)
    local name = args.fargs[1]
    stimpack.delete(name)
  end, {
    nargs = 1,
  })
  -- cmd updates a single plugin
  vim.api.nvim_create_user_command("StimUpdate", function(args)
    local name = args.fargs[1]
    stimpack.update(name, { force = true })
  end, {
    nargs = 1,
  })
  -- cmd gets info for a single plugin
  vim.api.nvim_create_user_command("StimGet", function(args)
    local name = args.fargs[1]
    stimpack.get(name)
  end, {
    nargs = 1,
  })
  -- cmd deletes all plugins on disk (be careful y'all!)
  vim.api.nvim_create_user_command("StimNuke", function()
    stimpack.nuke()
  end, {})
  -- cmd cleans up orphaned plugins
  vim.api.nvim_create_user_command("StimClean", function()
    stimpack.clean()
  end, {})
  -- cmd lists all plugins on disk
  vim.api.nvim_create_user_command("StimStatus", function()
    local spec_util = require("stimpack.spec")
    local lines = {}

    local function get_spec_by_name(name)
      for _, spec in ipairs(stimpack.config.specs) do
        local spec_name = spec.name or spec_util.get_name(spec_util.get_source(spec))
        if spec_name == name then
          return spec
        end
      end
      return nil
    end

    local function build_plugin_tree(spec, level, processed_plugins)
      local name = spec.name or spec_util.get_name(spec_util.get_source(spec))
      if processed_plugins[name] then
        return
      end
      processed_plugins[name] = true

      local rev
      if spec.dir then
        rev = "local"
      else
        local ok, info = pcall(vim.pack.get, { name }, { info = true })
        if ok and info and info[1] then
          rev = (info[1].rev or "N/A"):sub(1, 7)
        else
          rev = "unknown"
        end
      end

      local line = string.rep("  ", level) .. string.format("- %s (%s)", name, rev)
      table.insert(lines, line)

      if spec.dependencies then
        local deps = spec_util.flatten_specs(spec.dependencies)
        for _, dep_spec in ipairs(deps) do
          local dep_name = dep_spec.name or spec_util.get_name(spec_util.get_source(dep_spec))
          local full_dep_spec = get_spec_by_name(dep_name)
          if full_dep_spec then
            build_plugin_tree(full_dep_spec, level + 1, processed_plugins)
          end
        end
      end
    end

    local dependency_plugins = {}
    for _, spec in ipairs(stimpack.config.specs) do
      if spec.dependencies then
        local deps = spec_util.flatten_specs(spec.dependencies)
        for _, dep_spec in ipairs(deps) do
          local dep_name = dep_spec.name or spec_util.get_name(spec_util.get_source(dep_spec))
          dependency_plugins[dep_name] = true
        end
      end
    end

    local top_level_plugins = {}
    for _, spec in ipairs(stimpack.config.specs) do
      local name = spec.name or spec_util.get_name(spec_util.get_source(spec))
      if not dependency_plugins[name] then
        table.insert(top_level_plugins, spec)
      end
    end

    local processed_plugins = {}
    for _, spec in ipairs(top_level_plugins) do
      build_plugin_tree(spec, 0, processed_plugins)
    end

    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    vim.notify("Stimpack does not yet track plugin load times.", vim.log.levels.INFO)
  end, {})
end

return M
