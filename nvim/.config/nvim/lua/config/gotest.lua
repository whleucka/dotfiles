-- `go test` runner, the Go counterpart to config.phpunit: same keys, same
-- output split (config.testterm).
local M = {}

local testterm = require("config.testterm")

local function is_test(name)
  for _, prefix in ipairs({ "Test", "Benchmark", "Fuzz", "Example" }) do
    if vim.startswith(name, prefix) then
      return true
    end
  end
  return false
end

local function func_name(node, bufnr)
  if node:type() ~= "function_declaration" then
    return nil
  end
  local name = node:field("name")[1]
  return name and vim.treesitter.get_node_text(name, bufnr)
end

-- The top-level func around the cursor. Methods never are tests, and a
-- t.Run closure is inside its parent Test func, which is what gets run.
local function enclosing_test()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return nil
  end
  while node do
    local name = func_name(node, 0)
    if name then
      return is_test(name) and name or nil
    end
    node = node:parent()
  end
end

local function file_tests()
  local ok, parser = pcall(vim.treesitter.get_parser, 0, "go")
  if not ok or not parser then
    return {}
  end
  local names = {}
  for child in parser:parse()[1]:root():iter_children() do
    local name = func_name(child, 0)
    if name and is_test(name) then
      table.insert(names, name)
    end
  end
  return names
end

-- -run takes one regex; benchmarks only run under -bench, and -run ^$ keeps
-- the tests in the package from running alongside them.
local function filter(names)
  local tests, benches = {}, {}
  for _, n in ipairs(names) do
    table.insert(vim.startswith(n, "Benchmark") and benches or tests, n)
  end
  local args = { "-run", #tests > 0 and ("^(" .. table.concat(tests, "|") .. ")$") or "^$" }
  if #benches > 0 then
    vim.list_extend(args, { "-bench", "^(" .. table.concat(benches, "|") .. ")$" })
  end
  return args
end

---@param scope "nearest"|"file"|"suite"
function M.run(scope)
  local root = vim.fs.root(0, { "go.mod" })
  if not root then
    return vim.notify("go test: no go.mod above this file", vim.log.levels.WARN)
  end

  if scope == "suite" then
    return testterm.open({ "go", "test", "./..." }, root)
  end

  local file = vim.api.nvim_buf_get_name(0)
  if not vim.endswith(file, "_test.go") then
    return vim.notify("go test: not a _test.go file", vim.log.levels.WARN)
  end

  local names
  if scope == "nearest" then
    local name = enclosing_test()
    if not name then
      return vim.notify("go test: cursor is not inside a Test/Benchmark/Fuzz/Example func", vim.log.levels.WARN)
    end
    names = { name }
  else
    names = file_tests()
    if #names == 0 then
      return vim.notify("go test: no tests in this file", vim.log.levels.WARN)
    end
  end

  -- go test takes packages, not files: run the file's package, filtered.
  local pkg = "./" .. (vim.fs.relpath(root, vim.fs.dirname(file)) or ".")
  local cmd = { "go", "test", "-v", pkg }
  vim.list_extend(cmd, filter(names))
  testterm.open(cmd, root)
end

M.rerun = testterm.rerun

return M
