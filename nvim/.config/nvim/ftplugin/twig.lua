-- Deliberately NOT `vim.bo.filetype = "html"`. That coercion existed for html
-- highlighting, but it also handed .twig buffers to vscode-html-language-server,
-- which has no idea what {% %} is. queries/twig/injections.scm injects html into
-- (content) anyway, so the twig parser gives the html highlighting *and* the
-- template tags, with no language server attached.
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.bo.commentstring = "{# %s #}"
