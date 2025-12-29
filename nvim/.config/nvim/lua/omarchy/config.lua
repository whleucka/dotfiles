local M = {}

M.theme_file = os.getenv("HOME") .. "/.config/omarchy/current/theme/neovim.lua"

M.fallback_theme = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  event = "VimEnter",
  config = function()
    local config = require("config.catppuccin")
    require("catppuccin").setup(config)
    vim.cmd.colorscheme "catppuccin"
  end
}

return M
