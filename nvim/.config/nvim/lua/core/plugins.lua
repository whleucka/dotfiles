-- Plugins
require("plugins.which-key-nvim")
require('plugins.vim-fugitive')
require("plugins.omarchy")
require("plugins.oil-nvim")
require('plugins.fzf-lua')
require("plugins.lualine-nvim")
require("plugins.sshfs-nvim")
require("plugins.dashboard-nvim")

-- Lazy load these ones
local loaded_lazy_plugins = false

vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if not loaded_lazy_plugins and vim.bo[ev.buf].buftype == "" then
      loaded_lazy_plugins = true
      require('plugins.vim-repeat')
      require('plugins.vim-surround')
      require("plugins.nvim-treesitter")
      require('plugins.flash-nvim')
      require("plugins.blink-cmp")
      require("plugins.smart-splits-nvim")
      require("plugins.luasnip")
      require("plugins.gitsigns")
      require("plugins.bodybuilder-nvim")
    end
  end
})


