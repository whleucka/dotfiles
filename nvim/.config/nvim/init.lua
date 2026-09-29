-- Welcome to my Neovim configuration

-- Byte-compile cache for Lua modules. First, so it covers every require below
-- (it used to sit at the end of core.options, after stimpack had loaded most
-- of the config).
vim.loader.enable()

-- ui2: Nvim 0.12's redesigned message/cmdline UI (experimental). With
-- cmdheight=0 the legacy grid turned any message taller than the (empty)
-- cmdline into a hit-enter prompt; ui2 collapses long messages instead (g< to
-- expand) and shows them in an ephemeral "msg" window -- the target meant for
-- cmdheight=0. pcall'd so a future rename of this internal module degrades to
-- the legacy UI rather than breaking startup.
pcall(function()
  require("vim._core.ui2").enable({
    msg = { targets = "msg" },
  })
end)

require("core.globals")
vim.g.start_time = vim.fn.reltime()

-- Plugin loader
require("stimpack").setup()

-- Local plugins
require("radio").setup()

-- Other configurations
require("core.options")
require("core.autocmd")

vim.schedule(function()
  require("core.keymap")
end)

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("lsp-lazy-init", { clear = true }),
  once = true,
  callback = function()
    require("core.lsp")
  end,
})
