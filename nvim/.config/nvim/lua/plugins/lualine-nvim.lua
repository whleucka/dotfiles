return {
    "nvim-lualine/lualine.nvim",
    event = { "BufRead" },
    config = function()
      local config = require("config.lualine")
      require("lualine").setup(config)
    end,
}
