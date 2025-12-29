local M = {}

function M.setup()
  local theme_file = os.getenv("HOME") .. "/.config/omarchy/current/theme/neovim.lua"

  if vim.fn.filereadable(theme_file) ~= 0 then
    local poll_handle = vim.loop.new_fs_poll()
    vim.loop.fs_poll_start(poll_handle, theme_file, 1000, function()
      vim.schedule(function()
        vim.cmd("source " .. vim.env.MYVIMRC)
      end)
    end)
  end
end

return M
