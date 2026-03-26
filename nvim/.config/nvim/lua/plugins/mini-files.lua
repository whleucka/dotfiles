return {
  'nvim-mini/mini.files',
  keys = {
    {
      "<leader>o",
      function()
        MiniFiles.open()
      end,
      desc = "Open file explorer"
    },
  }
}
