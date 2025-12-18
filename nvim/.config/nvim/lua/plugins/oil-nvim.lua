return {
    "stevearc/oil.nvim",
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
