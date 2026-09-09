-- Welcome to my Neovim configuration
require("core.globals")
vim.g.start_time = vim.fn.reltime()

-- Plugin loader
require("stimpack").setup()

-- Local plugins
require("radio").setup()

-- Other configurations
require("core.options")
require("core.autocmd")

vim.schedule(function()
  require("core.keymap")
end)

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("lsp-lazy-init", { clear = true }),
  once = true,
  callback = function()
    require("core.lsp")
  end,
})
