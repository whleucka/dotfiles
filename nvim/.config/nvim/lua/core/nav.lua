-- super+hjkl: nvim splits -> kitty windows -> Hyprland windows.
--
-- Hyprland's super+hjkl runs ~/.config/hypr/scripts/nav, which injects
-- ctrl+alt+hjkl into kitty when the focused kitty window is running (n)vim.
-- Here that chord moves between nvim splits; at the nvim edge it hands back to
-- `nav --edge`, which tries the kitty split that way and then the Hyprland
-- window. Outside Hashiru the script is absent and the edge is just the edge.
--
-- The script only injects into an editor that opted in: we set the kitty user
-- variable hashiru_nav=1 while running and clear it on suspend and exit, so a
-- stock nvim (or this one over ssh, where the script is absent) is left alone.
--
-- alt+hjkl resizes: the divider moves in the key's direction (smart-splits
-- semantics), whichever side of it the cursor is on. Hyprland's super+ctrl+hjkl
-- injects it too (`nav --resize`); with no split on that axis we hand back to
-- `nav --resize --edge`, which resizes the kitty split, then the Hyprland window.
local M = {}

local hypr_nav = vim.fn.expand("~/.config/hypr/scripts/nav")

function M.nav(key)
  local before = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(key)
  if vim.api.nvim_get_current_win() == before and vim.fn.executable(hypr_nav) == 1 then
    vim.system({ hypr_nav, "--edge", key }, { detach = true })
  end
end

function M.resize(key, amount)
  amount = amount or 3
  local horizontal = key == "h" or key == "l"
  local before, after = "h", "l"
  if not horizontal then before, after = "k", "j" end
  local has_after = vim.fn.winnr(after) ~= vim.fn.winnr()
  if not has_after and vim.fn.winnr(before) == vim.fn.winnr() then
    -- No split on this axis: hand off to the kitty split, then Hyprland.
    if vim.fn.executable(hypr_nav) == 1 then
      vim.system({ hypr_nav, "--resize", "--edge", key }, { detach = true })
    end
    return
  end
  -- With a window `after` us we own the divider on that side: moving toward it
  -- grows us. Without one, our divider is on the `before` side: moving toward
  -- `after` shrinks us.
  local grow = (key == after) == has_after
  vim.cmd((horizontal and "vertical " or "") .. "resize " .. (grow and "+" or "-") .. amount)
end

-- OSC 1337 SetUserVar; kitty wants the value base64-encoded ("MQ==" is "1").
local function set_optin(on)
  if not vim.env.KITTY_WINDOW_ID or vim.fn.executable(hypr_nav) == 0 then return end
  local seq = "\027]1337;SetUserVar=hashiru_nav=" .. (on and "MQ==" or "") .. "\007"
  if vim.api.nvim_ui_send then
    vim.api.nvim_ui_send(seq)
  else
    vim.api.nvim_chan_send(vim.v.stderr, seq)
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("hashiru_nav", { clear = true })
  vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
    group = group, callback = function() set_optin(true) end,
  })
  vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
    group = group, callback = function() set_optin(false) end,
  })
  -- init.lua defers setup() with vim.schedule, past VimEnter.
  if vim.v.vim_did_enter == 1 then set_optin(true) end
  for _, key in ipairs({ "h", "j", "k", "l" }) do
    vim.keymap.set("n", "<C-M-" .. key .. ">", function() M.nav(key) end, { desc = "Navigate " .. key })
    vim.keymap.set("n", "<A-" .. key .. ">", function() M.resize(key) end, { desc = "Resize " .. key })
  end
end

return M
