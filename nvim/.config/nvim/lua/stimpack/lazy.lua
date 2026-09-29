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

-- Autocmds a plugin creates while it loads never see the event that loaded
-- it: Nvim does not run autocmds added mid-dispatch. That is exactly how
-- plugins hook in (dashboard's UIEnter/VimEnter, render-markdown's FileType
-- attach), so load, then re-fire the trigger event for just the new ones.
-- Not every autocmd carries an `id` (Vimscript-defined ones don't), so fall
-- back to identifying it by its contents.
local function _au_key(au)
  return au.id
    or table.concat({ tostring(au.group), au.pattern or "", au.command or "", tostring(au.callback) }, "\0")
end

local function _load_and_replay(load_handler)
  return function(args)
    local before = {}
    for _, au in ipairs(vim.api.nvim_get_autocmds({ event = args.event })) do
      before[_au_key(au)] = true
    end

    load_handler()

    local groups, loose = {}, {}
    for _, au in ipairs(vim.api.nvim_get_autocmds({ event = args.event })) do
      if not before[_au_key(au)] then
        if au.group then
          groups[au.group] = true
        elseif au.callback then
          table.insert(loose, au)
        end
      end
    end
    if next(groups) == nil and #loose == 0 then
      return
    end

    local function replay()
      for group in pairs(groups) do
        pcall(vim.api.nvim_exec_autocmds, args.event, {
          group = group,
          -- Pattern is matched against <amatch> (the filetype for FileType,
          -- the file name for BufRead*, the pattern for User).
          pattern = args.match ~= "" and args.match or nil,
          modeline = false,
          data = args.data,
        })
      end
      for _, au in ipairs(loose) do
        pcall(au.callback, vim.tbl_extend("force", args, { id = au.id }))
        if au.once then
          pcall(vim.api.nvim_del_autocmd, au.id)
        end
      end
    end

    if args.buf and args.buf ~= vim.api.nvim_get_current_buf() and vim.api.nvim_buf_is_valid(args.buf) then
      vim.api.nvim_buf_call(args.buf, replay)
    else
      replay()
    end
  end
end

function M.setup_loading(spec, pack, dep_names, load_handler)
  if spec.event then
    local events = _normalize_event(spec.event)
    if _in_table(events, "VeryLazy") then
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "VeryLazy",
        callback = _load_and_replay(load_handler),
      })
    else
      vim.api.nvim_create_autocmd(events, {
        once = true,
        callback = _load_and_replay(load_handler),
      })
    end
  end

  if spec.ft then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = spec.ft,
      once = true,
      callback = _load_and_replay(load_handler),
    })
  end

  if spec.cmd then
    local cmds = type(spec.cmd) == "table" and spec.cmd or { spec.cmd }
    for _, cmd in ipairs(cmds) do
      vim.api.nvim_create_user_command(cmd, function(cmd_args)
        -- self-destruct to avoid recursion if the plugin doesn't (re)define this cmd
        pcall(vim.api.nvim_del_user_command, cmd)
        load_handler()
        -- re-execute the original invocation with all its args/mods intact
        pcall(vim.api.nvim_cmd, {
          cmd = cmd,
          bang = cmd_args.bang,
          args = cmd_args.fargs,
          range = cmd_args.range > 0 and { cmd_args.line1, cmd_args.line2 } or nil,
          count = cmd_args.count >= 0 and cmd_args.count or nil,
          mods = cmd_args.smods,
        }, {})
      end, { bang = true, nargs = "*", range = true, complete = "file" })
    end
  end

  if spec.keys then
    local keys = type(spec.keys) == "function" and spec.keys() or spec.keys

    -- Recursively extract actual keymaps from nested which-key-style groups
    local function extract_keymaps(tbl, result)
      result = result or {}
      for _, item in ipairs(tbl) do
        if type(item) == "table" then
          local lhs = item[1]
          local rhs = item[2]
          if type(lhs) == "string" and (type(rhs) == "string" or type(rhs) == "function") then
            table.insert(result, item)
          end
          for i = 2, #item do
            if type(item[i]) == "table" then
              extract_keymaps({ item[i] }, result)
            end
          end
        end
      end
      return result
    end

    local keymaps = extract_keymaps(keys)
    for _, keymap in ipairs(keymaps) do
      local lhs = keymap[1]
      local rhs = keymap[2]
      local mode = keymap.mode or "n"
      local opts = { desc = keymap.desc }

      vim.keymap.set(mode, lhs, function()
        pcall(vim.keymap.del, mode, lhs)
        load_handler()
        if type(rhs) == "function" then
          rhs()
        elseif type(rhs) == "string" then
          local keys_to_feed = vim.api.nvim_replace_termcodes(rhs, true, false, true)
          vim.api.nvim_feedkeys(keys_to_feed, "m", false)
        end
      end, opts)
    end
  end
end

return M
