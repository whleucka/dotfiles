local function safe_require(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify(
      ("Failed loading %s\n%s"):format(mod, err),
      vim.log.levels.WARN
    )
  end
  return ok
end

-- Plugins
safe_require("plugins.which-key-nvim")
safe_require("plugins.oil-nvim")
safe_require('plugins.fzf-lua')
safe_require("plugins.sshfs-nvim")
safe_require("plugins.dashboard-nvim")
safe_require('plugins.neogit')

-- Lazy load these ones
local loaded_lazy_plugins = false

vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if not loaded_lazy_plugins and vim.bo[ev.buf].buftype == "" then
      loaded_lazy_plugins = true
      safe_require("plugins.lualine-nvim")
      safe_require('plugins.vim-repeat')
      safe_require('plugins.vim-surround')
      safe_require("plugins.nvim-treesitter")
      safe_require('plugins.flash-nvim')
      safe_require("plugins.blink-cmp")
      safe_require("plugins.luasnip")
      safe_require("plugins.gitsigns")
      safe_require("plugins.bodybuilder-nvim")
    end
  end
})
