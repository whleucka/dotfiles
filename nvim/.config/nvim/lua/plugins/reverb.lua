local sound_dir = vim.fn.stdpath("config") .. "/sound_effects/"
return {
  "https://github.com/whleucka/reverb.nvim",
  event = "VeryLazy",
  opts = {
    player = "paplay",
    sounds = {
      VimLeavePre = { path = sound_dir .. "fah.mp3", volume = 60 },
      BufWritePost = { path = sound_dir .. "ff8-save.mp3", volume = 65 },
      BufEnter = { path = sound_dir .. "balloon.mp3", volume = 60 },
      TextYankPost = { path = sound_dir .. "yoink.mp3", volume = 50 },
      ModeChanged = { path = sound_dir .. "bell.oga", volume = 50 },
      -- only package updates
      PackChanged = { path  = sound_dir .. "1up.mp3", volume = 65 , pattern = "update" },
      User = {
        { path  = sound_dir .. "coin.mp3", volume = 65, pattern = "NeogitCommitComplete" },
        { path  = sound_dir .. "flawless.mp3", volume = 65, pattern = "NeogitPushComplete" },
      }
    },
  },
}
