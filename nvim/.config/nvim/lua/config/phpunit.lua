-- PHPUnit runner. Deliberately plugin-free: toggleterm is lazy-loaded behind a
-- :TermExec stub, and passing a --filter regex through that command's string
-- parser means quoting a `$` anchor inside nested quotes. jobstart takes the
-- command as a list, so nothing gets re-parsed by a shell.
local M = {}

local testterm = require("config.testterm")

-- nil = auto (use the compose php container when one is up), false = always
-- run on the host. Toggled with <leader>Td.

local function docker(args)
  local res = vim.system(vim.list_extend({ "docker" }, args), { text = true }):wait()
  if res.code ~= 0 then
    return nil
  end
  return vim.trim(res.stdout)
end

-- The compose stack's php service, found by the label Compose stamps on every
-- container with the directory it was started from. Returns the container
-- name and its bind mounts so host paths can be rewritten to container paths:
-- the hydra app mounts itself at /var/www/html/app whatever the host dir is.
local function container(root)
  if vim.g.phpunit_docker == false or vim.fn.executable("docker") == 0 then
    return nil
  end
  local name = docker({
    "ps",
    "--filter", "label=com.docker.compose.project.working_dir=" .. root,
    "--filter", "label=com.docker.compose.service=php",
    "--format", "{{.Names}}",
  })
  name = name and vim.split(name, "\n")[1]
  if not name or name == "" then
    return nil
  end
  local mounts = vim.json.decode(docker({ "inspect", name, "--format", "{{json .Mounts}}" }) or "[]")
  return { name = name, mounts = mounts }
end

-- Longest bind-mount source that contains the path wins.
local function to_container(ctr, path)
  local best
  for _, m in ipairs(ctr.mounts) do
    local src = m.Source
    if (path == src or vim.startswith(path, src .. "/")) and (not best or #src > #best.Source) then
      best = m
    end
  end
  return best and (best.Destination .. path:sub(#best.Source + 1)) or nil
end

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

---@param scope "nearest"|"file"|"suite"
function M.run(scope)
  local root, bin = project()
  if not root then
    return vim.notify("phpunit: no vendor/bin/phpunit above this file", vim.log.levels.WARN)
  end

  local ctr = container(root)
  local workdir = ctr and to_container(ctr, root)
  local cmd
  if workdir then
    -- -t: jobstart's term gives docker a pty, so phpunit sees a terminal.
    cmd = { "docker", "exec", "-t", "-w", workdir, ctr.name, "vendor/bin/phpunit", "--colors=always" }
  else
    cmd = { bin, "--colors=always" }
  end

  if scope ~= "suite" then
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
      return vim.notify("phpunit: buffer has no file", vim.log.levels.WARN)
    end
    if workdir then
      file = to_container(ctr, file)
      if not file then
        return vim.notify("phpunit: file is not mounted in " .. ctr.name, vim.log.levels.WARN)
      end
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

  testterm.open(cmd, root)
end

function M.toggle_docker()
  if vim.g.phpunit_docker == false then
    vim.g.phpunit_docker = nil
  else
    vim.g.phpunit_docker = false
  end
  vim.notify("phpunit: " .. (vim.g.phpunit_docker == false and "host only" or "docker when available"))
end

M.rerun = testterm.rerun

return M
