-- Shared test-output split for the per-language runners (config.phpunit,
-- config.gotest). One window at a time; a new run replaces the last.
local M = {}

local state = { win = nil, last = nil }

local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
end

---@param cmd string[] run as a list by jobstart, so nothing is re-parsed by a shell
---@param cwd string
function M.open(cmd, cwd)
  close()

  local origin = vim.api.nvim_get_current_win()
  vim.cmd("botright 15new")
  state.win = vim.api.nvim_get_current_win()

  vim.fn.jobstart(cmd, { term = true, cwd = cwd })
  state.last = { cmd = cmd, cwd = cwd }

  vim.bo.buflisted = false
  vim.keymap.set("n", "q", close, { buffer = 0, silent = true, desc = "Close test output" })

  -- Read the results where the cursor already was, not in the terminal.
  if vim.api.nvim_win_is_valid(origin) then
    vim.api.nvim_set_current_win(origin)
  end
end

function M.rerun()
  if not state.last then
    return vim.notify("test: nothing run yet", vim.log.levels.WARN)
  end
  M.open(state.last.cmd, state.last.cwd)
end

return M
