return {
  ensure_installed = {
    'php',
    'bash',
    'c',
    'css',
    'html',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'rust',
    'sql',
    'javascript',
  },
  auto_install = true,
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Enter>",
      node_incremental = "<Enter>",
      scope_incremental = false,
      node_decremental = "<BS>",
    },
  },
  fold = {
    enable = true,
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  }
}
