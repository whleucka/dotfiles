return {
  "https://github.com/hedyhli/outline.nvim",
  opts = {
    keymaps = {
      up_and_jump = '<C-p>',
      down_and_jump = '<C-n>',
    }
  },
  keys = {
    { "<leader>o", ":topleft Outline<CR>", desc = "Toggle Outline" }
  }
}
