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
  "ty",
})

-- Nvim 0.12 LSP features that are off unless asked for. Each one is gated on
-- the server actually advertising it.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-features", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local buf = args.buf

    -- Editing an HTML open tag renames its close tag as you type (html, and
    -- any other server that implements it).
    if client:supports_method("textDocument/linkedEditingRange") then
      vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
    end

    -- Colour literals get a swatch. "virtual" rather than the default
    -- background fill: a coloured cell is opaque under kitty's translucency,
    -- and a swatch leaves the literal itself readable.
    if client:supports_method("textDocument/documentColor") then
      vim.lsp.document_color.enable(true, { bufnr = buf }, { style = "virtual" })
    end

    -- Types and parameter names inline (rust-analyzer, clangd, intelephense).
    -- <leader>ch toggles them for the buffer when they get noisy.
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
  end,
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
