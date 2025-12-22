-- lua/stimpack/build.lua
local M = {}

function M.run(spec, pack_name)
  if not spec.build then
    return
  end

  local plugin_path
  if spec.dir then
    plugin_path = spec.dir
  else
    local info_list = vim.pack.get({ pack_name }, { info = true })
    if not info_list or #info_list == 0 or not info_list[1].path then
      vim.notify("STIMPACK: Could not find path for " .. pack_name .. " to run build.", vim.log.levels.WARN)
      return
    end
    plugin_path = info_list[1].path
  end

  vim.notify("STIMPACK: Building " .. pack_name .. "...", vim.log.levels.INFO)

  local build_cmd = spec.build
  local success = false
  if type(build_cmd) == "string" then
    if build_cmd:sub(1, 1) == ":" then
      -- this is a vim command
      local ok, err = pcall(vim.cmd, build_cmd)
      if ok then
        success = true
      else
        vim.notify("STIMPACK: Failed to build " .. pack_name .. ":\n" .. err, vim.log.levels.ERROR)
      end
    else
      -- this is a shell command
      local result = vim.fn.system("cd " .. vim.fn.shellescape(plugin_path) .. " && " .. build_cmd)
      if vim.v.shell_error == 0 then
        success = true
      else
        vim.notify("STIMPACK: Failed to build " .. pack_name .. ":\n" .. result, vim.log.levels.ERROR)
      end
    end
  elseif type(build_cmd) == "function" then
    local ok, err = pcall(build_cmd)
    if ok then
      success = true
    else
      vim.notify("STIMPACK: Failed to build " .. pack_name .. ":\n" .. err, vim.log.levels.ERROR)
    end
  end

  if success then
    vim.notify("STIMPACK: Successfully built " .. pack_name, vim.log.levels.INFO)
  end
end

return M
