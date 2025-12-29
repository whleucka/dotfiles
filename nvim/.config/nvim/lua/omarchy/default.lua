return {
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
