-- Captured terminal output with its ANSI escape sequences intact, from any
-- `--color=always` capture: `cmd &> /tmp/out.ansi` then open it.
--
-- baleia is packadd'd here rather than through the plugin spec: nvim's built-in
-- filetypeplugin autocmd fires before stimpack's ft loader, so waiting on the
-- spec would colorize the buffer before the plugin is on the runtimepath.
local buf = vim.api.nvim_get_current_buf()

vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.wrap = false -- keep TUI box drawing / columns aligned (`:set wrap` to read long lines)
vim.opt_local.list = false
vim.opt_local.spell = false
vim.opt_local.signcolumn = "no"
vim.opt_local.foldcolumn = "0"
vim.opt_local.conceallevel = 0

pcall(vim.cmd.packadd, "baleia.nvim")
local ok, baleia = pcall(require, "baleia")
if ok then
  -- once(): strip the escape codes and lay down the equivalent highlights. The
  -- dump is static, so there is nothing to keep watching. Synchronous so the
  -- buffer is final before the trim and the jump-to-end below.
  -- pcall'd because baleia defines one highlight group per distinct color
  -- combination, and a dump with thousands of unique truecolor pairs can hit
  -- E849 (too many highlight groups) — better a partly-colored buffer than none.
  local colorized, err = pcall(function()
    baleia.setup({ line_starts_at = 1, async = false }).once(buf)
  end)
  if not colorized then
    vim.notify("ansi: colorizing stopped early — " .. tostring(err), vim.log.levels.WARN)
  end
else
  vim.notify("ansi: baleia.nvim not available — showing raw escape codes", vim.log.levels.WARN)
end

-- Screen captures pad out to the terminal height; those trailing empties are
-- just dead space.
local last = vim.api.nvim_buf_line_count(buf)
while last > 1 and vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1]:match("^%s*$") do
  last = last - 1
end
if last < vim.api.nvim_buf_line_count(buf) then
  vim.api.nvim_buf_set_lines(buf, last, -1, false, {})
end
