return {
  keymap = {
    preset = "super-tab",
    ["<C-e>"] = { "select_and_accept", "fallback" },
  },

  snippets = { preset = "luasnip" },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    keyword = { range = "full" },

    trigger = {
      show_on_backspace = true,
      show_on_backspace_in_keyword = true,
    },

    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },

    accept = {
      auto_brackets = {
        enabled = true,
      },
    },

    menu = {
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "kind" },
        },
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },

    ghost_text = {
      enabled = true,
      show_with_selection = true,
      show_without_selection = false,
      show_with_menu = true,
      show_without_menu = false,
    },
  },

  signature = {
    enabled = true,
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      lsp = { score_offset = 3 },
      path = { score_offset = 2 },
      snippets = { score_offset = 1 },
      buffer = { score_offset = 0 },
    },
  },

  fuzzy = {
    implementation = "rust",
    sorts = { "exact", "score", "sort_text" },
    frecency = { enabled = true },
    use_proximity = true,
  },
}
