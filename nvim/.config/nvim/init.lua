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
-- Keymaps go through which-key.add(), which requires which-key (~5ms). Run it
-- on the first event-loop tick so the first frame is not blocked by it.
vim.schedule(function()
  require("core.keymap")
end)

-- LSP setup pulls in vim.lsp + vim.diagnostic (~14ms), which is pure cost on a
-- dashboard-only session. Defer to the first real buffer; vim.lsp.enable()
-- attaches retroactively, so nothing is missed when opening a file directly.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("lsp-lazy-init", { clear = true }),
  once = true,
  callback = function()
    require("core.lsp")
  end,
})
