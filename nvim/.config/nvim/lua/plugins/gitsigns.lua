local with = require("core.utils").with

vim.pack.add {
  "https://github.com/lewis6991/gitsigns.nvim",
}

with("which-key", function(m)
  local gitsigns = require("gitsigns")
  m.add({
    {
      "]c",
      function()
        require("gitsigns").nav_hunk('next')
      end,
      desc = "Next hunk"
    },
    {
      "[c",
      function()
        require("gitsigns").nav_hunk('prev')
      end,
      desc = "Prev hunk"
    },
    {
      "<leader>gh",
      group = "Hunk",
      { "<leader>ghs", gitsigns.stage_hunk,          desc = "Stage" },
      { "<leader>ghr", gitsigns.reset_hunk,          desc = "Reset" },
      { "<leader>ghp", gitsigns.preview_hunk,        desc = "Preview" },
      { "<leader>ghP", gitsigns.preview_hunk_inline, desc = "Preview inline" },
      {
        "<leader>ghb",
        function()
          gitsigns.blame_line({ full = true })
        end,
        desc = "Blame line"
      },
    }
  })
end)
