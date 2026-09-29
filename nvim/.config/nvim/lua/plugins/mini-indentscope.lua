-- The scope line is noise in non-code buffers. Registered at spec-load time
-- (stimpack has no `init`) so it's in place before the dashboard opens.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("mini-indentscope-disable", { clear = true }),
  pattern = { "help", "dashboard", "minifiles", "NeogitStatus", "toggleterm", "nvim-pack", "markdown" },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

return {
  "nvim-mini/mini.indentscope",
  event = "VeryLazy",
  opts = {
    symbol = "│",
    options = { try_as_border = true },
    draw = {
      delay = 50,
    },
  },
}
