local M = {}

local function _notify(level, msg)
  vim.schedule(function() vim.notify(msg, level) end)
end

local function _resolve_path(spec, pack_name)
  if spec.dir then
    return vim.fn.expand(spec.dir)
  end
  local info_list = vim.pack.get({ pack_name }, { info = true })
  if not info_list or #info_list == 0 or not info_list[1].path then
    return nil
  end
  return info_list[1].path
end

function M.run(spec, pack_name)
  if not spec.build then
    return
  end

  local plugin_path = _resolve_path(spec, pack_name)
  if not plugin_path then
    _notify(vim.log.levels.WARN,
      "STIMPACK: Could not find path for " .. pack_name .. " to run build.")
    return
  end

  _notify(vim.log.levels.INFO, "STIMPACK: Building " .. pack_name .. "...")

  local build_cmd = spec.build

  if type(build_cmd) == "function" then
    local ok, err = pcall(build_cmd)
    if ok then
      _notify(vim.log.levels.INFO, "STIMPACK: Successfully built " .. pack_name)
    else
      _notify(vim.log.levels.ERROR,
        "STIMPACK: Failed to build " .. pack_name .. ":\n" .. tostring(err))
    end
    return
  end

  if type(build_cmd) ~= "string" then
    _notify(vim.log.levels.ERROR,
      "STIMPACK: `build` must be a string or function for " .. pack_name)
    return
  end

  if build_cmd:sub(1, 1) == ":" then
    -- vim command (run synchronously on the main thread)
    local ok, err = pcall(vim.cmd, build_cmd)
    if ok then
      _notify(vim.log.levels.INFO, "STIMPACK: Successfully built " .. pack_name)
    else
      _notify(vim.log.levels.ERROR,
        "STIMPACK: Failed to build " .. pack_name .. ":\n" .. tostring(err))
    end
    return
  end

  -- shell command: run async so the UI stays responsive
  vim.system(
    { vim.o.shell, "-c", build_cmd },
    { cwd = plugin_path, text = true },
    function(res)
      if res.code == 0 then
        _notify(vim.log.levels.INFO, "STIMPACK: Successfully built " .. pack_name)
      else
        local out = (res.stderr ~= nil and res.stderr ~= "") and res.stderr or res.stdout or ""
        _notify(vim.log.levels.ERROR,
          ("STIMPACK: Failed to build %s (exit %d):\n%s"):format(pack_name, res.code, out))
      end
    end
  )
end

return M
