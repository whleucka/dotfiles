-- This will record startup time
vim.g.__nvim_start_time = vim.loop.hrtime()

require("stimpack").setup()

require("core.omarchy")
require("core.globals")
require("core.options")
require("core.autocmd")
require("core.lsp")
