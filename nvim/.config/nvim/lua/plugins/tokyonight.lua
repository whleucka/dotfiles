return {
  "folke/tokyonight.nvim",
  config = function()
    require("tokyonight")
    vim.cmd[[colorscheme tokyonight]]
  end
}
