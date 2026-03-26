return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    auto_save = true,
    auto_restore = true,
    suppress_dirs = { "~/", "~/Downloads", "/tmp", "~/.mount/**" },
    pre_save_cmds = {
      -- Close any SSHFS buffers before saving the session
      function()
        local mount_dir = vim.fn.expand("~/.mount")
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(buf)
          if name:find(mount_dir, 1, true) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end,
    },
  },
}
