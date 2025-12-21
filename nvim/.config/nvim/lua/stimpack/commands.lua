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
end

return M
