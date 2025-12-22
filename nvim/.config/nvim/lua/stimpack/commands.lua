-- lua/stimpack/commands.lua
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
  -- cmd lists all plugins on disk
  vim.api.nvim_create_user_command("StimStatus", function()
    local spec_util = require("stimpack.spec")
    local lines = {}
    for _, spec in ipairs(stimpack.config.specs) do
      local name = spec.name or spec_util.get_name(spec_util.get_source(spec))
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
      table.insert(lines, string.format("%s (%s)", name, rev))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    vim.notify("Stimpack does not yet track plugin load times.", vim.log.levels.INFO)
  end, {})
end

return M
