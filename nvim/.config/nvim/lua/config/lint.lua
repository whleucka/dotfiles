local M = {}

-- phpstan.neon.dist (level 5, treatPhpDocTypesAsCertain off, phpVersion pinned
-- to the 8.2-8.5 span) is only found if the process starts at the repo root.
-- Run from the buffer's directory instead and phpstan silently analyses at
-- default level with none of that.
local function phpstan_root(bufnr)
  return vim.fs.root(bufnr or 0, { "phpstan.neon", "phpstan.neon.dist" })
end

-- nvim-lint resolves `cmd` through its own eval (functions allowed) but reads
-- `cwd` raw as a string, so the working directory has to be set per run rather
-- than declared once as a function on the linter.
function M.run(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lint = require("lint")

  if vim.bo[bufnr].filetype == "php" then
    local root = phpstan_root(bufnr)
    -- No config reachable: every write outside a phpstan project would
    -- otherwise spawn a doomed analyser.
    if not root then
      return
    end
    lint.linters.phpstan.cwd = root
  end

  lint.try_lint()
end

function M.setup()
  local lint = require("lint")

  lint.linters_by_ft = {
    php = { "phpstan" },
  }

  -- phpstan/phpstan is a require-dev pin, not a global install. The builtin
  -- resolves 'vendor/bin/phpstan' relative to the process cwd; resolve it from
  -- the buffer instead so it works before M.run has set cwd.
  lint.linters.phpstan.cmd = function()
    local root = phpstan_root(0)
    local vendored = root and (root .. "/vendor/bin/phpstan")
    if vendored and vim.fn.executable(vendored) == 1 then
      return vendored
    end
    return "phpstan"
  end

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("nvim-lint-on-write", { clear = true }),
    callback = function(args)
      M.run(args.buf)
    end,
  })
end

return M
