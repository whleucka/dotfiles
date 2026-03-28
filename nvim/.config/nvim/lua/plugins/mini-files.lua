return {
  'nvim-mini/mini.files',
  event = "VeryLazy",
  opts = {
    windows = {
      preview = true,
    },
    mappings = {
      go_in_plus = "l"
    },
  },
  keys = {
    {
      "<leader>o",
      function()
        if not MiniFiles.close() then
          MiniFiles.open(vim.api.nvim_buf_get_name(0))
        else
          MiniFiles.close()
        end
      end,
      desc = "Open file explorer"
    },
  }
}
