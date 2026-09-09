local M = {}

function M.with(mod, fn)
  local ok, m = pcall(require, mod)
  if ok then
    fn(m)
  end
end

-- Vim's alternate file (#) gets clobbered by pickers, terminals, help and
-- preview buffers, so keep our own MRU stack of real editable buffers.
local mru = {}
local MRU_MAX = 10

local function is_real(buf)
  return vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buflisted
      and vim.bo[buf].buftype == ""
end

function M.track_buffer(buf)
  if not is_real(buf) then return end
  for i = #mru, 1, -1 do
    if mru[i] == buf or not vim.api.nvim_buf_is_valid(mru[i]) then
      table.remove(mru, i)
    end
  end
  table.insert(mru, 1, buf)
  for i = #mru, MRU_MAX + 1, -1 do
    table.remove(mru, i)
  end
end

-- Most recently visited real buffer that isn't the current one.
function M.last_buffer()
  local cur = vim.api.nvim_get_current_buf()
  for i = 1, #mru do
    if mru[i] ~= cur and is_real(mru[i]) then
      return mru[i]
    end
  end
end

return M
