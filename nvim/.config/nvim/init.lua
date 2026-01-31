require("core.globals")
vim.g.start_time = vim.fn.reltime()

-- Plugin loader
require("stimpack").setup({
  -- additional_specs = require('omarchy'),
})

-- Other configurations
require("core.options")
require("core.autocmd")
require("core.lsp")
