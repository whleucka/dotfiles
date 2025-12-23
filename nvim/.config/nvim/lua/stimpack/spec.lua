local M = {}

local function _safe_require(mod)
  local ok, result = pcall(require, mod)
  if not ok then
    -- plugin failed to load
    vim.notify(
      ("STIMPACK: Failed loading %s\n%s"):format(mod, result),
      vim.log.levels.WARN
    )
    return nil
  end
  return result
end

function M.get_source(spec)
  local source
  if type(spec) == "string" then
    source = spec
  else
    source = spec[1]
  end

  if not string.find(source, "^http") then
    -- ensure a slash between github base and path
    if source:sub(1, 1) ~= "/" then
      source = "/" .. source
    end
    -- assume github url?
    source = "https://github.com" .. source
  end
  return source
end

function M.get_name(source)
  local name = source:match(".*/(.*)")
  if name and name:sub(-4) == ".git" then
    name = name:sub(1, -5)
  end
  return name or source
end

function M.pack_spec(spec, lazy)
  -- the goal is the mimic the vim.pack plugin spec
  -- see https://neovim.io/doc/user/pack.html
  local pack = {}
  local source = M.get_source(spec)
  pack.src = source

  if type(spec) == "table" then
    pack.name = spec.name or M.get_name(source)
    if spec.version then
      pack.version = spec.version
    end
    if spec.build then
      pack.build = spec.build
    end
    if spec.data then
      pack.data = spec.data
    end
  else
    pack.name = M.get_name(source)
  end

  if lazy then
    pack.opt = true
  end

  return pack
end

function M.load_all(dir, prefix)
  local specs = {}
  for name, type in vim.fs.dir(dir) do
    -- get all the lua files in the plugin dir
    if type == "file" and name:sub(-4) == ".lua" then
      -- strip off .lua
      local basename = name:gsub("%.lua$", "")
      local spec = _safe_require(prefix .. "." .. basename)
      if spec then
        -- add spec to specs
        table.insert(specs, spec)
      end
    end
  end
  -- higher priority plugins should load first
  local default_priority = 50
  table.sort(specs, function(a, b)
    return (a.priority or default_priority) > (b.priority or default_priority)
  end)
  return specs
end

return M
