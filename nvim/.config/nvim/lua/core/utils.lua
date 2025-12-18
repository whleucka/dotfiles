local M = {}

function M.with(mod, fn)
  local ok, m = pcall(require, mod)
  if ok then
    fn(m)
  end
end

return M
