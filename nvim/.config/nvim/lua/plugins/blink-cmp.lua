return {
  "saghen/blink.cmp",
  dependencies = {
    "saghen/blink.lib",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },
  event = "InsertEnter",
  opts = require("config.blink"),
  build = function()
    -- blink keys its compiled rust library to the git commit it read at
    -- module-load time. STIMPACK runs this build in-process right after an
    -- update, so a blink.cmp already require()d this session still holds the
    -- pre-update commit and the artifact lands under the wrong hash (and is
    -- "not available" on next launch). Drop the cached module so the rebuild
    -- re-reads the freshly-updated HEAD.
    package.loaded["blink.cmp"] = nil
    require("blink.cmp").build():pwait()
  end,
}
