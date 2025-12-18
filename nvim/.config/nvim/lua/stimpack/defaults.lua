local M = {}

function M.get()
  return {
    paths = {
      plugins = vim.fn.stdpath("config") .. "/lua/plugins",
    }
  }
end

return M
