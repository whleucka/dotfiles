local explore_quickfix = function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and 'cclose' or 'copen')
end
local explore_locations = function()
  vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and 'lclose' or 'lopen')
end

return {
  'nvim-mini/mini.files',
  event = "VeryLazy",
  opts = {
    windows = {
      preview = true,
    },
    mappings = {
      go_in = "<NOP>",
      go_in_plus = "l"
    },
  },
  keys = {
    {
      "<leader>e",
      group = "Explore",
      {
        {
          "<leader>o",
          function()
            -- close() returns false when there was no explorer to close
            if not MiniFiles.close() then
              MiniFiles.open(vim.api.nvim_buf_get_name(0))
            end
          end,
          desc = "Toggle file explorer"
        },
        {
          "<leader>ed",
          function() MiniFiles.open() end,
          desc = "Files (cwd)"
        },
        {
          "<leader>ef",
          function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end,
          desc = "Files (current file)"
        },
        {
          "<leader>eq",
          explore_quickfix,
          desc = "Quickfix list"
        },
        {
          "<leader>el",
          explore_locations,
          desc = "Location list"
        },
      }
    }
  }
}
