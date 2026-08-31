return {
  "folke/tokyonight.nvim",
  config = function()
    require("tokyonight").setup({
      style = "night",
      styles = {
        comments = { italic = true },
      },
      on_highlights = function(hl, c)
        -- Stock tokyonight comments are #565f89 -> 2.76:1 on the night bg, well
        -- under the 4.5:1 readability threshold. This lands at 5.16:1: legible,
        -- but still dimmer than the #c0caf5 code around it.
        local comment = "#828bb8"
        hl.Comment = { fg = comment, italic = true }
        hl["@comment"] = { fg = comment, italic = true }
        hl["@comment.documentation"] = { fg = comment, italic = true }
        -- Keep doc/note tags from falling back to the old dim value
        hl.SpecialComment = { fg = comment, italic = true }
      end,
    })
    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
