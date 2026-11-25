-- Indentation itself comes from treesitter (config.treesitter sets
-- 'indentexpr', which overrules 'cindent'/'cinoptions' -- those used to be set
-- here and did nothing). Only the width is ours to choose.
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
