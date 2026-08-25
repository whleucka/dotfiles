vim.lsp.enable({
  "bashls",
  "clangd",
  "cssls",
  "html",
  -- "htmx", -- disabled: htmx-lsp advertises hoverProvider but returns garbage,
  --            which kills vim.lsp.buf.hover() on every ft it attaches to
  --            (php/js/ts/html/twig/markdown). Config kept in lsp/htmx.lua.
  "intelephense",
  "lua_ls",
  "ruff",
  "rust_analyzer",
  "sqls",
  "ts_ls",
})

vim.diagnostic.config({
  -- virtual_text = true,
  -- virtual_lines = {
  --   current_line = true,
  -- },
  virtual_text = { current_line = true },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})
