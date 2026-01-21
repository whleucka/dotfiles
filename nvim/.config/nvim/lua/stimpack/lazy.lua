local M = {}

local function _in_table(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

local function _normalize_event(event)
  if not event then
    return {}
  end

  if type(event) == "string" then
    return { event }
  end

  if type(event) == "table" then
    return event
  end

  error("event must be a string or table of strings")
end

function M.setup_loading(spec, pack, dep_names, load_handler)
  if spec.event then
    local events = _normalize_event(spec.event)
    if _in_table(events, "VeryLazy") then
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "VeryLazy",
        callback = load_handler,
      })
    else
      vim.api.nvim_create_autocmd(events, {
        once = true,
        callback = load_handler,
      })
    end
  end

  if spec.ft then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = spec.ft,
      once = true,
      callback = load_handler,
    })
  end

  if spec.cmd then
    local cmds = type(spec.cmd) == "table" and spec.cmd or { spec.cmd }
    for _, cmd in ipairs(cmds) do
      vim.api.nvim_create_user_command(cmd, function(cmd_args)
        -- Remove the self-destructing command to avoid infinite loop if the plugin doesn't define it
        vim.api.nvim_del_user_command(cmd)
        load_handler()
        -- Re-execute the command if the plugin defined it
        pcall(function()
          local args_str = ""
          if cmd_args.fargs and #cmd_args.fargs > 0 then
            local V = vim.fn
            local largs = {}
            for _, val in ipairs(cmd_args.fargs) do
              table.insert(largs, V.string(val))
            end
            args_str = " " .. table.concat(largs, " ")
          end

          vim.cmd(string.format("%s%s%s", cmd, cmd_args.bang and "!" or "", args_str))
        end)
      end, { bang = true, nargs = "*", complete = "file" }) -- Generic params
    end
  end
end

return M
