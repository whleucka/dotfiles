-- super+hjkl: nvim splits -> kitty windows -> Hyprland windows.
--
-- Hyprland's super+hjkl runs ~/.config/hypr/scripts/nav, which injects
-- ctrl+alt+hjkl into kitty when the focused kitty window is running (n)vim.
-- Here that chord moves between nvim splits; at the nvim edge it hands back to
-- `nav --edge`, which tries the kitty split that way and then the Hyprland
-- window. Outside Hashiru the script is absent and the edge is just the edge.
--
-- alt+hjkl resizes: the divider moves in the key's direction (smart-splits
-- semantics), whichever side of it the cursor is on.
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
    return -- no split on this axis
  end
  -- With a window `after` us we own the divider on that side: moving toward it
  -- grows us. Without one, our divider is on the `before` side: moving toward
  -- `after` shrinks us.
  local grow = (key == after) == has_after
  vim.cmd((horizontal and "vertical " or "") .. "resize " .. (grow and "+" or "-") .. amount)
end

function M.setup()
  for _, key in ipairs({ "h", "j", "k", "l" }) do
    vim.keymap.set("n", "<C-M-" .. key .. ">", function() M.nav(key) end, { desc = "Navigate " .. key })
    vim.keymap.set("n", "<A-" .. key .. ">", function() M.resize(key) end, { desc = "Resize " .. key })
  end
end

return M
