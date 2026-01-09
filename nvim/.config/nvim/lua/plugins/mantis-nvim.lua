return {
  enabled = true,
  dir = "/home/whleucka/Projects/mantis-nvim",
<<<<<<< HEAD
  name = "mantis-nvim",
  event = "VimEnter",
  keys = {
    { "<leader>M", ":Mantis<cr>", desc = "Mantis Issues" },
  },
  dependencies = {
    "grapp-dev/nui-components.nvim",
    "MunifTanjim/nui.nvim"
  },
  opts = require("config.mantis-nvim")
=======
  event = "VimEnter",
  keys = {
    { "<leader>e", ":Mantis<cr>", desc = "Mantis" },
  },
  config = function()
    require("mantis").setup({
      debug = false,
      hosts = {
        williamhleucka = {
          url = "https://mantis.williamhleucka.com",
          token = "gpYB3wZDDWxm0i0HvMHON2mfMkmq8cSh"
        },
        chainlogic = {
          url = "https://mantis.chainlogic.it",
          token = "_RNzBd8Y2nDXS2_wR-rghoEfbfJDQ_J2"
        },
      }
    })
  end
>>>>>>> 8fc7b3f (fix: update a few things)
}
