vim.g.start_time = vim.fn.reltime()

require("stimpack").setup({
  additional_specs = require('omarchy'),
})

require("core.globals")
require("core.options")
require("core.autocmd")
require("core.lsp")
