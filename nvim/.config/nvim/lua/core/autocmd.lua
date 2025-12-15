-- Highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 150, on_visual = true })
  end,
})

-- Restore last cursor pos
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup('restore-cursor-pos', { clear = true }),
  callback = function(args)
    local buf = args.buf
    local pos = vim.api.nvim_buf_get_mark(buf, '"')
    local lines = vim.api.nvim_buf_line_count(buf)
    if pos[1] > 0 and pos[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, pos)
    end
  end,
})

-- Auto reload file if changed
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = vim.api.nvim_create_augroup('auto-reload-file', { clear = true }),
  command = "checktime"
})

-- Enable spellcheck
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup('enable-spellcheck', { clear = true }),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Clear search
vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup('clear-search-cursor-move', { clear = true }),
  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.mode() == "n" then
      vim.cmd("nohlsearch")
    end
  end,
})

-- Close with q
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close-with-q", { clear = true }),
  pattern = { "help", "man", "qf", "oil", "nvim-pack", "fugitive", "git" },
  callback = function(ev)
    -- buffer-local mapping so it doesn't steal "q" globally
    vim.keymap.set("n", "q", function()
      -- close floats or regular windows
      local cfg = vim.api.nvim_win_get_config(0)
      if cfg and cfg.relative ~= "" then
        vim.api.nvim_win_close(0, true)
      else
        vim.cmd.close()
      end
    end, { buffer = ev.buf, silent = true, desc = "Close window with q" })

    -- don't list these buffers
    vim.bo[ev.buf].buflisted = false
  end,
})
