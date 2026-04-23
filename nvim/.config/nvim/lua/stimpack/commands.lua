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

  -- cmd runs the build step for a single plugin
  vim.api.nvim_create_user_command("StimBuild", function(args)
    local spec_util = require("stimpack.spec")
    local build = require("stimpack.build")
    local name = args.fargs[1]
    for _, spec in ipairs(stimpack.config.specs) do
      local spec_name = type(spec) == "string" and spec_util.get_name(spec)
        or spec.name
        or spec_util.get_name(spec_util.get_source(spec))
      if spec_name == name then
        if type(spec) == "table" and not spec.build then
          vim.notify("STIMPACK: No build step for " .. name, vim.log.levels.WARN)
          return
        end
        pcall(vim.cmd.packadd, name)
        build.run(spec, name)
        return
      end
    end
    vim.notify("STIMPACK: Plugin not found in specs: " .. name, vim.log.levels.WARN)
  end, {
    nargs = 1,
    complete = function()
      local spec_util = require("stimpack.spec")
      local names = {}
      for _, spec in ipairs(stimpack.config.specs) do
        if type(spec) == "table" and spec.build then
          local n = spec.name or spec_util.get_name(spec_util.get_source(spec))
          table.insert(names, n)
        end
      end
      return names
    end,
  })

  vim.api.nvim_create_user_command("StimProfile", function()
    local spec_util = require("stimpack.spec")
    local stats = stimpack.get_stats()
    local stimpack_startup_ms = stats.startup_time_ms
    local plugins = stats.loaded_plugins
    local plugin_load_times = stats.plugin_load_times
    local total_plugin_load_time = 0
    for _, time in pairs(plugin_load_times) do
      total_plugin_load_time = total_plugin_load_time + time
    end

    local profile_lines = {
      "--- Stimpack Profile ---",
      string.format("💉 Stimpack configured (%d plugins) in %.2fms", plugins, stimpack_startup_ms),
      string.format("🔌 Plugins loaded in %.2fms", total_plugin_load_time),
    }

    if stats.ui_ready_time_ms then
      table.insert(profile_lines, string.format("⚡ UI Ready Time: %.2fms", stats.ui_ready_time_ms))
    else
      table.insert(profile_lines, "⚡ UI Ready Time: Not yet available (run after VimEnter)")
    end

    table.insert(profile_lines, "") -- Add a blank line for separation
    table.insert(profile_lines, "--- Plugin Tree ---")

    local tree_lines = {}

    local function build_plugin_tree(spec, level, processed_plugins)
      local name
      if type(spec) == "table" then
        name = spec.name or spec_util.get_name(spec_util.get_source(spec))
      else
        name = spec_util.get_name(spec_util.get_source(spec))
      end

      if processed_plugins[name] then
        return
      end
      processed_plugins[name] = true

      local rev
      local valid_plugin = true
      if type(spec) == "table" and spec.dir then
        local dir_path = vim.fn.expand(spec.dir)
        if vim.fn.isdirectory(dir_path) == 1 then
          rev = "local"
        else
          rev = "not found"
          valid_plugin = false
        end
      else
        local ok, info = pcall(vim.pack.get, { name }, { info = true })
        if ok and info and info[1] then
          rev = (info[1].rev or "N/A"):sub(1, 7)
        else
          rev = "unknown"
        end
      end

      local line
      local load_time = plugin_load_times[name]
      if load_time then
        line = string.rep("  ", level) .. string.format("- %s (%s, %.2fms)", name, rev, load_time)
      else
        line = string.rep("  ", level) .. string.format("- %s (%s)", name, rev)
      end
      table.insert(tree_lines, line)

      if valid_plugin and type(spec) == "table" and spec.dependencies then
        local deps = spec_util.flatten_specs(spec.dependencies)
        for _, dep_spec in ipairs(deps) do
          build_plugin_tree(dep_spec, level + 1, processed_plugins)
        end
      end
    end

    local processed_plugins = {}
    for _, spec in ipairs(stimpack.config.specs) do
      build_plugin_tree(spec, 0, processed_plugins)
    end

    vim.notify(table.concat(profile_lines, "\n") .. "\n" .. table.concat(tree_lines, "\n"), vim.log.levels.INFO)
  end, {})
end

return M

