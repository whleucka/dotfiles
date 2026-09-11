-- PHPUnit runner. Deliberately plugin-free: toggleterm is lazy-loaded behind a
-- :TermExec stub, and passing a --filter regex through that command's string
-- parser means quoting a `$` anchor inside nested quotes. jobstart takes the
-- command as a list, so nothing gets re-parsed by a shell.
local M = {}

local state = { win = nil, last = nil }

-- Root on vendor/bin/phpunit, not on phpunit.xml or composer.json. Every
-- packages/*/ in the monorepo carries its own composer.json and its own
-- phpunit.xml whose bootstrap="vendor/autoload.php" is relative to a vendor/
-- that only exists once, at the repo root -- those configs are for the split
-- read-only repos, where the package dir *is* where composer installed. The
-- directory holding vendor/bin/phpunit is the right answer in both layouts.
local function project(bufnr)
  local start = vim.api.nvim_buf_get_name(bufnr or 0)
  if start == "" then
    start = vim.fn.getcwd()
  end

  for dir in vim.fs.parents(start) do
    local vendored = dir .. "/vendor/bin/phpunit"
    if vim.fn.executable(vendored) == 1 then
      return dir, vendored
    end
  end

  -- No composer install anywhere above: fall back to a global phpunit run from
  -- the nearest config, so this still works outside a composer project.
  local cfg = vim.fs.root(bufnr or 0, { "phpunit.xml", "phpunit.xml.dist" })
  if cfg and vim.fn.executable("phpunit") == 1 then
    return cfg, "phpunit"
  end

  return nil
end

-- Walk up from the cursor to the enclosing method. Falls back to the class so
-- <leader>Tt outside a test body still narrows to something useful.
local function enclosing_test()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return nil
  end
  while node do
    local kind = node:type()
    if kind == "method_declaration" or kind == "class_declaration" then
      local name = node:field("name")[1]
      if name then
        return kind, vim.treesitter.get_node_text(name, 0)
      end
    end
    node = node:parent()
  end
  return nil
end

local function open(cmd, cwd)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  local origin = vim.api.nvim_get_current_win()
  vim.cmd("botright 15new")
  state.win = vim.api.nvim_get_current_win()

  vim.fn.jobstart(cmd, { term = true, cwd = cwd })

  vim.bo.buflisted = false
  vim.keymap.set("n", "q", function()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_close(state.win, true)
    end
  end, { buffer = 0, silent = true, desc = "Close test output" })

  -- Read the results where the cursor already was, not in the terminal.
  if vim.api.nvim_win_is_valid(origin) then
    vim.api.nvim_set_current_win(origin)
  end
end

---@param scope "nearest"|"file"|"suite"
function M.run(scope)
  local root, bin = project()
  if not root then
    return vim.notify("phpunit: no vendor/bin/phpunit above this file", vim.log.levels.WARN)
  end

  local cmd = { bin, "--colors=always" }

  if scope ~= "suite" then
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
      return vim.notify("phpunit: buffer has no file", vim.log.levels.WARN)
    end
    table.insert(cmd, file)
  end

  if scope == "nearest" then
    local kind, name = enclosing_test()
    if not name then
      return vim.notify("phpunit: no enclosing method or class", vim.log.levels.WARN)
    end
    -- ::name$ anchors to one method; a bare class name matches the whole class.
    vim.list_extend(cmd, { "--filter", kind == "method_declaration" and ("::" .. name .. "$") or name })
  end

  state.last = { cmd = cmd, cwd = root }
  open(cmd, root)
end

function M.rerun()
  if not state.last then
    return vim.notify("phpunit: nothing run yet", vim.log.levels.WARN)
  end
  open(state.last.cmd, state.last.cwd)
end

return M
