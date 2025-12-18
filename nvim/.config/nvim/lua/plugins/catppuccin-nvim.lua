return {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      local config = require("config.catppuccin")
      require("catppuccin").setup(config)
      vim.cmd.colorscheme "catppuccin"
      vim.cmd [[
        hi Normal guibg=NONE ctermbg=NONE
        hi NormalNC guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE ctermbg=NONE
        hi LineNr guibg=NONE ctermbg=NONE
        hi EndOfBuffer guibg=NONE ctermbg=NONE
      ]]
   end
}
