-- after/, not ftplugin/: $VIMRUNTIME/ftplugin/go.vim already sets noexpandtab
-- and shiftwidth=0 (follow tabstop) -- gofmt's tabs. Only the tab width is
-- left to choose; the runtime default of 8 is wider than any Go code you'll read.
vim.bo.tabstop = 4

-- gofmt (gofumpt, via gopls) plus import fixing on every write is the Go
-- convention, and code review expects it. Organize imports first, since its
-- edits are not formatted.
local function organize_imports(buf, client)
  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = { only = { "source.organizeImports" }, diagnostics = {} }
  local res = client:request_sync("textDocument/codeAction", params, 1000, buf)
  for _, action in ipairs(res and res.result or {}) do
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("go-fmt-" .. vim.api.nvim_get_current_buf(), { clear = true }),
  buffer = 0,
  callback = function(args)
    local client = vim.lsp.get_clients({ bufnr = args.buf, name = "gopls" })[1]
    if not client then
      return
    end
    organize_imports(args.buf, client)
    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
  end,
})

local gotest = require("config.gotest")

local function map(lhs, fn, desc)
  vim.keymap.set("n", lhs, fn, { buffer = 0, silent = true, desc = desc })
end

map("<leader>Tt", function() gotest.run("nearest") end, "Nearest test")
map("<leader>Tf", function() gotest.run("file") end, "File tests")
map("<leader>Ta", function() gotest.run("suite") end, "Whole module")
map("<leader>Tl", gotest.rerun, "Rerun last")

pcall(function()
  require("which-key").add({ { "<leader>T", group = "Test", buffer = 0 } })
end)
