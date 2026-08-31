-- dashboard-nvim paints the whole header with one DashboardHeader group, so a
-- per-line gradient has to be overlaid afterwards in our own namespace.
local gradient = { "#2ac3de", "#4d9fe8", "#7aa2f7", "#8f9ef9", "#a795f8", "#bb9af7" }
local rule_fg = "#828bb8"
local ns = vim.api.nvim_create_namespace("dashboard_banner_gradient")

local function define_highlights()
  for i, hex in ipairs(gradient) do
    vim.api.nvim_set_hl(0, "DashboardBanner" .. i, { fg = hex, bold = true })
  end
  vim.api.nvim_set_hl(0, "DashboardBannerRule", { fg = rule_fg })
end

-- The banner's bottom row is drawn entirely in ╚═╝ with no █ at all, so match
-- on either character or that line silently loses its gradient step.
local function is_art(line)
  return line:find("█", 1, true) or line:find("╚", 1, true)
end

local function paint(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  define_highlights()
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  -- hyper prepends a block of blank lines to vertically centre the buffer only
  -- after the header is drawn, so the banner's row offset is not knowable up
  -- front -- scan the whole buffer and stop once the rule line is painted.
  local step = 0
  for row, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    local group
    if is_art(line) then
      step = step + 1
      group = "DashboardBanner" .. math.min(step, #gradient)
    elseif line:find("n  e  o  v  i  m", 1, true) then
      group = "DashboardBannerRule"
    end
    if group then
      vim.api.nvim_buf_set_extmark(bufnr, ns, row - 1, 0, {
        end_row = row - 1,
        end_col = #line,
        hl_group = group,
        -- generate_header() paints DashboardHeader via nvim_buf_add_highlight,
        -- which defaults to priority 4096 -- must outrank it or the gradient is
        -- present but invisible.
        priority = 5000,
      })
      if group == "DashboardBannerRule" then
        return
      end
    end
  end
end

return {
  "nvimdev/dashboard-nvim",
  priority = 0, -- load this plugin last to get accurate startup time
  event = "VimEnter",
  config = function()
    local config = require("config.dashboard")

    -- Precomputed here, not in the footer callback: stimpack.get_stats() calls
    -- vim.pack.get(), which yields to the event loop, and the footer runs in the
    -- middle of hyper's buffer write where a yield corrupts the render. Nothing
    -- is drawing yet at this point, so yielding here is free. The elapsed time
    -- is deliberately left to the footer -- stimpack registers its VimEnter
    -- handler after this plugin loads, so ui_ready_time_ms is still nil here.
    pcall(function()
      vim.g.dashboard_plugin_count = require("stimpack").get_stats().loaded_plugins or 0
    end)

    -- Register before setup(): setup() renders synchronously, so any event it
    -- emits has already fired by the time it returns.
    local group = vim.api.nvim_create_augroup("dashboard-banner-gradient", { clear = true })
    -- FileType fires before the header lines exist, so hook DashboardLoaded --
    -- the only event emitted after the centring lines are prepended.
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "DashboardLoaded",
      callback = function()
        pcall(paint, vim.api.nvim_get_current_buf())
      end,
    })
    -- Re-derive the groups if the colorscheme is swapped while sitting here.
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = function()
        pcall(define_highlights)
      end,
    })

    require("dashboard").setup(config)
  end,
  keys = {
    { "<leader>D", ":Dashboard<cr>", desc = "Dashboard" },
  },
}
