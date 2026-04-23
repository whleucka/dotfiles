local M = {}

local function _safe_require(mod)
  local ok, result = pcall(require, mod)
  if not ok then
    vim.notify(
      ("STIMPACK: Failed loading %s\n%s"):format(mod, result),
      vim.log.levels.WARN
    )
    return nil
  end
  return result
end

local function _looks_like_url(s)
  return s:match("^https?://")
    or s:match("^git@")
    or s:match("^ssh://")
    or s:match("^git://")
    or s:match("^file://")
end

local function _looks_like_shorthand(s)
  -- owner/repo — permissive on chars, forbids spaces and extra slashes
  return s:match("^[%w%-_%.]+/[%w%-_%.]+$") ~= nil
end

function M.get_source(spec)
  local source
  if type(spec) == "string" then
    source = spec
  elseif type(spec) == "table" and spec.dir then
    source = spec.dir
  else
    source = spec[1]
  end

  if type(source) ~= "string" then
    error("STIMPACK: spec must include a source string or `dir`")
  end

  if _looks_like_url(source) then
    return source
  end

  if _looks_like_shorthand(source) then
    return "https://github.com/" .. source
  end

  -- not a URL and not owner/repo — leave as-is (e.g. insteadOf aliases like `gh:user/repo`)
  return source
end

function M.get_name(source)
  local name = source:match(".*/(.*)")
  if name and name:sub(-4) == ".git" then
    name = name:sub(1, -5)
  end
  return name or source
end

function M.pack_spec(spec)
  -- mirrors vim.pack.Spec: src, name, version, data
  local pack = {}
  local source = M.get_source(spec)
  pack.src = source

  if type(spec) == "table" then
    pack.name = spec.name or M.get_name(source)
    if spec.version then
      pack.version = spec.version
    end
    if spec.data then
      pack.data = spec.data
    end
  else
    pack.name = M.get_name(source)
  end

  return pack
end

function M.load_all(dir, prefix)
  local specs = {}
  for name, type_ in vim.fs.dir(dir) do
    if type_ == "file" and name:sub(-4) == ".lua" then
      local basename = name:gsub("%.lua$", "")
      local spec = _safe_require(prefix .. "." .. basename)
      if spec then
        table.insert(specs, spec)
      end
    end
  end
  return specs
end

function M.flatten_specs(specs)
  local flat_specs = {}
  if not specs then
    return flat_specs
  end
  for _, item in ipairs(specs) do
    -- A group is a table whose first positional entry is itself a table-spec
    -- (individual plugin specs have [1] = "owner/repo" string or use `dir`)
    if type(item) == "table" and type(item[1]) == "table" then
      local sub_specs = M.flatten_specs(item)
      for _, sub_item in ipairs(sub_specs) do
        table.insert(flat_specs, sub_item)
      end
    else
      table.insert(flat_specs, item)
    end
  end
  return flat_specs
end

return M
