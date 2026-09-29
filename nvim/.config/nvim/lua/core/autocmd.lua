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
  callback = function(args)
    -- LSP hover/signature floats are markdown too (buftype=nofile); spell
    -- there just undercurls every @param and type name. Set false outright:
    -- a new float copies 'spell' from the window it was opened from.
    vim.opt_local.spell = vim.bo[args.buf].buftype == ""
  end,
})

-- Clear search highlight after 'updatetime' idle or on entering insert mode.
-- Not a CursorMoved -> :nohlsearch autocmd: the search highlight state is
-- saved and restored around autocommands (:h autocmd-searchpat), so that was a
-- silent no-op. The bundled plugin feedkeys() the command to escape that.
vim.cmd.packadd("nohlsearch")

-- Indent guides follow the buffer's shiftwidth. 'listchars' is window-local
-- while 'shiftwidth' is buffer-local, so refresh whenever a buffer lands in a
-- window, its filetype sets the width, or the width changes later.
local function sync_indent_guides()
  local sw = vim.fn.shiftwidth() -- resolves shiftwidth=0 to 'tabstop'
  if sw < 1 then
    return
  end
  local lc = vim.opt_local.listchars:get()
  local guide = "·" .. string.rep(" ", sw - 1)
  if lc.leadmultispace ~= guide then
    lc.leadmultispace = guide
    vim.opt_local.listchars = lc
  end
end

local indent_guides = vim.api.nvim_create_augroup("indent-guides", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
  group = indent_guides,
  callback = sync_indent_guides,
})
vim.api.nvim_create_autocmd("OptionSet", {
  group = indent_guides,
  pattern = { "shiftwidth", "tabstop" },
  callback = sync_indent_guides,
})

-- Close with q
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close-with-q", { clear = true }),
  pattern = { "help", "man", "qf", "checkhealth", "nvim-pack" },
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

-- Captured terminal output (herdr scrollback dumps, CI logs) keeps its ANSI
-- escape sequences; ftplugin/ansi.lua turns them into real highlights.
vim.filetype.add({
  extension = {
    ansi = "ansi",
  },
})

-- Track recently visited buffers for <leader><leader>
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("track-buffer-mru", { clear = true }),
  callback = function(args)
    require("core.utils").track_buffer(args.buf)
  end,
})
