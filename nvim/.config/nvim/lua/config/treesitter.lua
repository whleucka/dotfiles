return {
  ensure_installed = {
    'lua', 'php', 'phpdoc', 'twig', 'html', 'css', 'bash', 'python', 'c', 'cpp', 'rust', 'sql', 'javascript', 'kitty',
  },
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Enter>",
      node_incremental = "<Enter>",
      scope_incremental = false,
      node_decremental = "<BS>",
    },
  },
}
