local function range()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    vim.cmd("normal! \27")
    local first, last = vim.fn.line("'<"), vim.fn.line("'>")
    return { line_start = math.min(first, last), line_end = math.max(first, last) }
  end
  local line = vim.fn.line(".")
  return { line_start = line, line_end = line }
end

local function do_hunks(action)
  return function()
    MiniDiff.do_hunks(0, action, range())
  end
end

local function do_buffer(action)
  return function()
    MiniDiff.do_hunks(0, action)
  end
end

local function goto_hunk(direction)
  return function()
    MiniDiff.goto_hunk(direction)
  end
end

local function hunks_to_quickfix()
  local items = MiniDiff.export("qf")
  if #items == 0 then
    return vim.notify("No hunks", vim.log.levels.INFO)
  end
  vim.fn.setqflist(items, " ")
  vim.cmd("copen")
end

local neogit_worktree_events = {
  "NeogitBranchCheckout",
  "NeogitBranchReset",
  "NeogitReset",
  "NeogitMerge",
  "NeogitRebase",
  "NeogitCherryPick",
  "NeogitStash",
  "NeogitPullComplete",
  "NeogitBisect",
}

return {
  "nvim-mini/mini.diff",
  event = "VeryLazy",
  config = function()
    require("mini.diff").setup({
      view = {
        style = "sign",
        signs = { add = "▎", change = "▎", delete = "▁" },
      },
      mappings = {
        apply = "gh",
        reset = "gH",
        textobject = "gh",
        goto_prev = "[c",
        goto_next = "]c",
        goto_first = "[C",
        goto_last = "]C",
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = neogit_worktree_events,
      group = vim.api.nvim_create_augroup("MiniDiffNeogit", { clear = true }),
      desc = "Reload buffers after Neogit rewrites the worktree",
      callback = function()
        vim.cmd("checktime")
      end,
    })
  end,
  keys = {
    { "]c", goto_hunk("next"), desc = "Next hunk" },
    { "[c", goto_hunk("prev"), desc = "Prev hunk" },
    {
      "<leader>gh",
      group = "Hunk",
      { "<leader>gho", function() MiniDiff.toggle_overlay(0) end, desc = "Toggle overlay" },
      { "<leader>ghs", do_hunks("apply"),                         desc = "Stage",         mode = { "n", "x" } },
      { "<leader>ghr", do_hunks("reset"),                         desc = "Reset",         mode = { "n", "x" } },
      { "<leader>ghS", do_buffer("apply"),                        desc = "Stage buffer" },
      { "<leader>ghR", do_buffer("reset"),                        desc = "Reset buffer" },
      { "<leader>ghq", hunks_to_quickfix,                         desc = "Hunks to quickfix" },
      { "<leader>ght", function() MiniDiff.toggle(0) end,         desc = "Toggle diff" },
    },
  },
}
