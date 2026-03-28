-- Welcome to my Neovim configuration
require("core.globals")
vim.g.start_time = vim.fn.reltime()

-- Plugin loader
require("stimpack").setup()

-- Other configurations
require("core.options")
require("core.autocmd")
require("core.lsp")
require("core.keymap")
