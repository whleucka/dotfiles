local sound_dir = vim.fn.stdpath("config") .. "/sound_effects/"
return {
  "https://github.com/whleucka/reverb.nvim",
  event = "VeryLazy",
  opts = {
    player = "paplay",
    sounds = {
      VimEnter = { path = { sound_dir .. "sega-hd.mp3" }, volume = 60 },
      VimLeavePre = { path = { sound_dir .. "sonic_exit.mp3" }, volume = 60 },
      BufWritePost = { path = { sound_dir .. "ff8-save.mp3" }, volume = 65 },
      BufEnter = { path = { sound_dir .. "balloon.mp3" }, volume = 60 },
      TextYankPost = { path = { sound_dir .. "yoink.mp3" }, volume = 50 },
      ModeChanged = { path = { sound_dir .. "bell.oga" }, volume = 50 },
      PackChanged = { path  = { sound_dir .. "1up.mp3" }, volume = 65 },
    },
  },
}
