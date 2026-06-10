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
          "<leader>eo",
          function()
            if not MiniFiles.close() then
              MiniFiles.open(vim.api.nvim_buf_get_name(0))
            else
              MiniFiles.close()
            end
          end,
          desc = "Open file explorer"
        },
        {
          "<leader>ed",
          ":lua MiniFiles.open()<CR>",
          desc = "Files (git)"
        },
        {
          "<leader>ef",
          ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>",
          desc = "Files (git)"
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
