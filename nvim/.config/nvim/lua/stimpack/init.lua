-- STIMPACK.NVIM

local M = {}

M.config = {}

local function _safe_require(mod)
  local ok, result = pcall(require, mod)
  if not ok then
    -- plugin failed to load
    vim.notify(
      ("Failed loading %s\n%s"):format(mod, result),
      vim.log.levels.WARN
    )
    return nil
  end
  return result
end

local function _load_specs(dir)
  local specs = {}
  for name, type in vim.fs.dir(dir) do
    -- get all the lua files in the plugin dir
    if type == "file" and name:sub(-4) == ".lua" then
      -- strip off .lua
      local basename = name:gsub("%.lua$", "")
      local spec = _safe_require("plugins." .. basename)
      if spec then
          -- add plugin to specs
          table.insert(specs, spec)
      end
    end
  end
  return specs
end

local function _get_source(spec)
    local source
    if type(spec) == "string" then
        source = spec
    else
        source = spec[1]
    end

    if not string.find(source, "^http") then
        -- ensure a slash between github base and path
        if source:sub(1,1) ~= "/" then
            source = "/" .. source
        end
        -- assume github url, I suppose?
        source = "https://github.com" .. source
    end
    return source
end

local function _pack_spec(spec)
    -- the goal is the mimic the vim.pack plugin spec
    -- see https://neovim.io/doc/user/pack.html 
    local pack = {}
    if type(spec) == "table" then
        local source = _get_source(spec)
        pack.src = source
        if spec.name then
            pack.name = spec.name
        end
        if spec.version then
            pack.version = spec.version
        end
    else
        local source = _get_source(spec)
        pack.src = source
    end
    return pack
end

local function _load_plugin(pack)
    vim.pack.add({ pack })
end

local function _load_plugins(specs)
    for i, spec in ipairs(specs) do
        -- try to load the dep specs, first
        if spec.dependencies then
            for i, dependency in ipairs(spec.dependencies) do
                local pack = _pack_spec(dependency)
                _load_plugin(pack)
            end
        end

        -- load main spec
        local pack = _pack_spec(spec)
        _load_plugin(pack)

        if spec.config then
            -- there is a config in the spec, run it
            spec.config()
        end
    end
end

local function _register_keys(specs)
    for i, spec in ipairs(specs) do
      if spec.keys then
        local with = require("core.utils").with
        with("which-key", function(m)
          m.add(spec.keys)
        end)
      end
    end
end

local function _defaults()
  return require("stimpack.defaults").get()
end

function M.setup(opts)
  opts = opts or {}

  -- warning, config is not validated!
  M.config = vim.tbl_deep_extend("force", _defaults(), opts)

  -- load the specs
  M.config.specs = _load_specs(M.config.paths.plugins)

  -- load the plugins
  _load_plugins(M.config.specs)

  -- register keybinds
  _register_keys(M.config.specs)
end

return M
