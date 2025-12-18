local with = require("core.utils").with

vim.pack.add {
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
  }
}

with("catppuccin", function(m)
  local config = require("config.catppuccin")
  m.setup(config)
  vim.cmd.colorscheme "catppuccin"
  vim.cmd [[
    hi Normal guibg=NONE ctermbg=NONE
    hi NormalNC guibg=NONE ctermbg=NONE
    hi SignColumn guibg=NONE ctermbg=NONE
    hi LineNr guibg=NONE ctermbg=NONE
    hi EndOfBuffer guibg=NONE ctermbg=NONE
  ]]
end)
