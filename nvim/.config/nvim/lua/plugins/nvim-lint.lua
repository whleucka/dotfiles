return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  -- nvim-lint has no setup(); it is configured by assigning to the module.
  config = function()
    require("config.lint").setup()
  end,
}
