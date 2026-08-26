return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.icons",
  },
  opts = {
    latex = { enabled = false },
    -- yaml frontmatter rendering needs the yaml parser, which is not in
    -- config.treesitter-modules' ensure_installed.
    yaml = { enabled = false },
    completions = { lsp = { enabled = true } },
  },
  keys = function()
    return {
      {
        "<leader>M",
        ":RenderMarkdown toggle<CR>",
        desc = "Toggle markdown render",
      },
    }
  end,
}
