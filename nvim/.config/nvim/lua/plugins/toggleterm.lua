-- Terminal-mode keys are taken from the program running in the terminal, so
-- stay off chords the shell and TUIs need: <C-w> is delete-word, <C-l> clear,
-- <C-h>/<C-j>/<C-k> backspace/accept/kill-line, and a bare <esc> belongs to
-- fzf, lazygit and friends.
local function set_terminal_keymaps(buf)
  local function map(lhs, rhs, desc)
    vim.keymap.set('t', lhs, rhs, { buffer = buf, desc = desc })
  end
  map('<esc><esc>', [[<C-\><C-n>]], 'Normal mode')
  map('jk', [[<C-\><C-n>]], 'Normal mode')
  map('kj', [[<C-\><C-n>]], 'Normal mode')

  -- The unified super+hjkl chord (Hyprland injects ctrl+alt+hjkl), so window
  -- navigation works from inside the terminal too, edge hand-off included.
  for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
    map('<C-M-' .. key .. '>', function()
      require("herdr-splits")["move_cursor_" .. dir]()
    end, 'Move cursor ' .. dir)
  end
end

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("toggleterm-keymaps", { clear = true }),
  pattern = "term://*toggleterm#*",
  callback = function(args)
    set_terminal_keymaps(args.buf)
  end,
})

return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermExec" },
  keys = {
    { '<C-\\>', ':ToggleTerm direction=horizontal size=20<cr>', desc = 'Toggle term (split)' },
  },
  opts = {
    float_opts = {
      border = "rounded",
    },
  }
}
