return {
  ensure_installed = {
    'php',
    -- queries/php_only/injections.scm injects phpdoc into every (comment) and
    -- regex into preg_* arguments. auto_install only ever fetches the parser
    -- for the buffer's own filetype, so injected languages have to be listed
    -- here or docblocks and patterns render as flat comment/string text.
    'phpdoc',
    'regex',
    'bash',
    'c',
    'css',
    'html',
    'json', -- composer.json
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'rust',
    'sql',
    'javascript',
    -- twig highlights {% %} itself and injects html into (content); it is
    -- what replaced coercing .twig buffers to filetype=html.
    'twig',
    'xml', -- phpunit.xml
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
