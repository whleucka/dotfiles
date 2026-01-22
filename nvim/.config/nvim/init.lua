vim.g.start_time = vim.fn.reltime()

require("core.globals")
require("stimpack").setup({
  additional_specs = require('omarchy'),
})

require("core.options")
require("core.autocmd")
require("core.lsp")
