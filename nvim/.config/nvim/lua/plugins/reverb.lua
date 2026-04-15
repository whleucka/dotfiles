local sound_dir = vim.fn.stdpath("config") .. "/sound_effects/"
return {
  "https://github.com/whleucka/reverb.nvim",
  event = "VeryLazy",
  opts = {
    player = "paplay",
    sounds = {
      BufWritePost = { path = { sound_dir .. "completion-success.oga" }, volume = 40 },
      BufEnter = { path = { sound_dir .. "bell.oga" }, volume = 40 },
    },
  },
}
