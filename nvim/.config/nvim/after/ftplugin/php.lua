-- after/ftplugin, not ftplugin: ~/.config/nvim sits *before* $VIMRUNTIME in
-- 'runtimepath', so ftplugin/php.lua is sourced first and then overwritten by
-- $VIMRUNTIME/ftplugin/php.vim. Anything that file also sets has to be set
-- again from after/ or it silently loses.

-- $VIMRUNTIME/ftplugin/php.vim sets `/* %s */`, so gcc produced block comments.
vim.bo.commentstring = "// %s"

-- `$` is not a keyword char by default, so `*` on `$user` searched for `user`,
-- and diw/ciw left the sigil behind.
vim.opt_local.iskeyword:append("$")

local phpunit = require("config.phpunit")

local function map(lhs, fn, desc)
  vim.keymap.set("n", lhs, fn, { buffer = 0, silent = true, desc = desc })
end

map("<leader>Tt", function() phpunit.run("nearest") end, "Nearest test")
map("<leader>Tf", function() phpunit.run("file") end, "File tests")
map("<leader>Ta", function() phpunit.run("suite") end, "Whole suite")
map("<leader>Tl", phpunit.rerun, "Rerun last")

pcall(function()
  require("which-key").add({ { "<leader>T", group = "Test", buffer = 0 } })
end)
