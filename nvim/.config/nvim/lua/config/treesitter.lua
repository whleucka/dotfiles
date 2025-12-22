return {
  enusre_installed = {
    'php',
    'bash',
    'c',
    'css',
    'html',
    'htmx',
    'lua',
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
  --fold = {
  --  true
  --},
  highlight = {
    enabled = true,
  },
  indent = {
    enable = true,
  }
}
