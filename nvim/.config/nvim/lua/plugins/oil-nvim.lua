return {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local config = require("config.oil")
      require("oil").setup(config)
    end,
    keys = {
        { "<leader>o", ":Oil<CR>", desc = "Oil" },
    }
}
