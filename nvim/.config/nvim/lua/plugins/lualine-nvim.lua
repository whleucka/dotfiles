return {
    "nvim-lualine/lualine.nvim",
    config = function()
      local config = require("config.lualine")
      require("lualine").setup(config)
    end,
}
