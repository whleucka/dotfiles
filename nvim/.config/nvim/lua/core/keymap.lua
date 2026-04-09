local keys = {
  {
    "<leader>?",
    function()
      require("which-key").show({ global = false })
    end,
    desc = "Help",
  },
  {
    "<leader>c",
    group = "Code",
    {
      "<leader>ca",
      function()
        vim.lsp.buf.code_action()
      end,
      desc = "Action"
    },
    {
      "<leader>cf",
      function()
        vim.lsp.buf.format({ async = true })
      end,
      desc = "Format"
    },
    {
      "<leader>cr",
      function()
        vim.lsp.buf.rename()
      end,
      desc = "Rename symbol"
    },
    {
      "<leader>cd",
      function()
        vim.diagnostic.open_float()
      end,
      desc = "Line diagnostics"
    },
    {
      "<leader>cs",
      function()
        vim.lsp.buf.signature_help()
      end,
      desc = "Signature help"
    },
    {
      "<leader>cl",
      function()
        vim.diagnostic.setloclist()
      end,
      desc = "Diagnostics to loclist"
    },
  },
  {
    "<leader>t",
    group = "Tab",
    { "<leader>tc", ":tabnew<CR>",   desc = "Create New" },
    { "<leader>tq", ":tabclose<CR>", desc = "Close" },
    { "<leader>tn", ":tabnext<CR>",  desc = "Next" },
    { "<leader>tp", ":tabprev<CR>",  desc = "Prev" },
    { "<leader>tf", ":tabfirst<CR>", desc = "First" },
    { "<leader>tl", ":tablast<CR>",  desc = "Last" },
  },
  {
    "<leader>s",
    group = "Split",
    { "<leader>sv", ":vsplit<CR>", desc = "Vertical" },
    { "<leader>sh", ":split<CR>",  desc = "Horizontal" },
    { "<leader>se", "<C-w>=",      desc = "Equalize" },
    { "<leader>sq", ":close<CR>",  desc = "Close" },
  },
  {
    "<leader>b",
    group = "Buffer",
    { "<leader>bc", ":enew<CR>",   desc = "Create New" },
    { "<leader>bq", ":bd<CR>",     desc = "Close" },
    { "<leader>bn", ":bnext<CR>",  desc = "Next" },
    { "<leader>bp", ":bprev<CR>",  desc = "Prev" },
    { "<leader>bf", ":bfirst<CR>", desc = "First" },
    { "<leader>bl", ":blast<CR>",  desc = "Last" },
  },
  {
    { "q",                "<nop>" },
    { "<esc><esc>",       ":noh<CR>" },
    { "<leader>q",       ":q<CR>",                                 desc = "Close window" },
    { "<leader>Q",        ":qa<CR>",                                desc = "Close Neovim" },
    { "<leader>w",        ":w!<CR>",                                desc = "Save" },
    { "H",                ":bprev<CR>",                             desc = "Previous Buffer" },
    { "L",                ":bnext<CR>",                             desc = "Previous Buffer" },
    { "<leader><leader>", ":b#<CR>",                                desc = "Last Buffer" },
    { "<leader>so",       ":update<CR> :source<CR>",                desc = "Source file", },
    { "gd",               ":lua vim.lsp.buf.definition()<cr>",      desc = "Go to definition" },
    { "gD",               ":lua vim.lsp.buf.declaration()<cr>",     desc = "Go to declaration" },
    { "gi",               ":lua vim.lsp.buf.implementation()<cr>",  desc = "Go to implementation" },
    { "gr",               ":lua vim.lsp.buf.references()<cr>",      desc = "Go to references" },
    { "gt",               ":lua vim.lsp.buf.type_definition()<cr>", desc = "Go to type definition" },
    { "K",                ":lua vim.lsp.buf.hover()<cr>",           desc = "Hover documentation" },
    { "<F5>",             ":restart<CR>",                           desc = "Restart" },
  },
  {
    mode = "i",
    { "jk", "<esc>" },
    { "kj", "<esc>" },
  },
  {
    mode = "v",
    { "<", "<gv",              desc = "Indent selected <" },
    { ">", ">gv",              desc = "Indent selected >" },
    { "J", ":m '>+1<CR>gv=gv", desc = "Move selected line down" },
    { "K", ":m '<-2<CR>gv=gv", desc = "Move selected line up" },
  },
}

require("which-key").add(keys)
