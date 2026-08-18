return {
  "nvim-treesitter/nvim-treesitter",
  version = "main",
  priority = 500,
  -- Loaded as a dependency of treesitter-modules (BufReadPost/BufNewFile) and
  -- render-markdown; the cmd list keeps :TS* usable before any file is opened.
  lazy = true,
  cmd = { "TSUpdate", "TSInstall", "TSUninstall", "TSLog", "TSInstallFromGrammar" },
  build = ":TSUpdate"
}
