local sound_dir = vim.fn.stdpath("config") .. "/sound_effects/"
return {
  "https://github.com/whleucka/reverb.nvim",
  opts = {
    player = "mpv",
    sounds = {
      BufWrite = { path = { sound_dir .. "ding.wav" }, volume = 100 },
      VimEnter = { path = { sound_dir .. "bell.mp3", volume = 80 } },
    },
  },
}
