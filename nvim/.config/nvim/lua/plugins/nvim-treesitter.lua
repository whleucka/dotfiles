return {
  "nvim-treesitter/nvim-treesitter",
  version = "main",
  priority = 500,
  -- BufReadPre, not BufReadPost: filetype detection runs inside BufReadPost,
  -- so config.treesitter's FileType hook has to exist before then. The cmd
  -- list keeps :TS* usable before any file is opened.
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "TSUpdate", "TSInstall", "TSUninstall", "TSLog", "TSInstallFromGrammar" },
  build = ":TSUpdate",
  config = function()
    require("config.treesitter").setup()
  end,
}
