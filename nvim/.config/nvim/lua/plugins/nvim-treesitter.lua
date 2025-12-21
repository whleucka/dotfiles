return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "MeanderingProgrammer/treesitter-modules.nvim"
    },
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()
      local config = require("config.treesitter")
      require("treesitter-modules").setup(config)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { '<filetype>' },
        callback = function() vim.treesitter.start() end,
      })
    end
}
