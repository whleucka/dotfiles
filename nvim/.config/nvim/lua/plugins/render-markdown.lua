return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.icons",
  },
  opts = {
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
