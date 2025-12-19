return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "MeanderingProgrammer/treesitter-modules.nvim"
    },
    config = function()
      local config = require("config.treesitter")
      require("nvim-treesitter").setup()
      require("treesitter-modules").setup(config)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { '<filetype>' },
        callback = function() vim.treesitter.start() end,
      })
    end
}
