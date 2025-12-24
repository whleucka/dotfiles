vim.g.start_time = vim.fn.reltime()

require("stimpack").setup()

require("core.omarchy")
require("core.globals")
require("core.options")
require("core.autocmd")
require("core.lsp")
