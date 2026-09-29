-- blink.cmp's plugin/ file registers these, but blink loads on InsertEnter --
-- after the first client has already started without them. (It only ever
-- worked because stimpack used to source every lazy plugin's plugin/ at
-- startup.) get_lsp_capabilities() is safe to call before blink's setup().
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
  vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
end

vim.lsp.enable({
  "bashls",
  "clangd",
  "cssls",
  "html",
  "intelephense",
  "lua_ls",
  "ruff",
  "rust_analyzer",
  "sqls",
  "ts_ls",
})

vim.diagnostic.config({
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
