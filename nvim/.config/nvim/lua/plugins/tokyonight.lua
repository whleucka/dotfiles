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
        -- Stock WinSeparator is c.border (#15161e), darker than the #1a1b26
        -- background, so split boundaries vanish. blue0 reads as a deliberate
        -- line without competing with the code.
        hl.WinSeparator = { fg = c.blue0, bold = false }

        -- kitty's background_opacity only reaches a cell whose background *is*
        -- the terminal default (#1a1b26). The tabline groups ship on c.black
        -- (#15161e) and c.bg_statusline (#16161e), so every one of them paints
        -- opaque and the strip reads as a black bar above a translucent buffer.
        --
        -- c.bg, not "NONE". A tabline group with no background does not fall
        -- back to Normal, it falls back to TabLineFill -- which is c.black, the
        -- very colour being escaped -- so "NONE" looks identical to doing
        -- nothing. Naming c.bg outright skips the fallback chain. TabLineFill
        -- is set too so nothing painting outside these groups reopens the hole.
        for _, group in ipairs({
          "TabLine",
          "TabLineFill",
          "MiniTablineFill",
          "MiniTablineHidden",
          "MiniTablineVisible",
          "MiniTablineModifiedHidden",
          "MiniTablineModifiedVisible",
          "MiniTablineTrunc",
        }) do
          hl[group] = vim.tbl_extend("force", hl[group] or {}, { bg = c.bg })
        end

        -- One accent for "active", tiered by area: c.blue on the small chips
        -- (this, the waybar workspace pill, the herdr tab, the statusline mode
        -- block) and the dimmer c.blue0 reserved for the one full-width band,
        -- the Hyprland groupbar, where c.blue glares. c.bg for the text because
        -- c.fg on c.blue is 1.9:1 -- unreadable -- while c.bg lands at 6.7:1.
        hl.MiniTablineCurrent = { fg = c.bg, bg = c.blue }
        hl.MiniTablineTabpagesection = { fg = c.bg, bg = c.blue }
        -- mini.tabline signals "unsaved" with colour alone, no glyph, so the
        -- chip has to change hue rather than just text: c.yellow on c.blue is
        -- 1.3:1 and would erase the distinction entirely.
        hl.MiniTablineModifiedCurrent = { fg = c.bg, bg = c.yellow }
      end,
    })
    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
