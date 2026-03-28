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
    }
  },
  {
    "<leader>w",
    group = "Window",
    { "<leader>wc", ":new<CR>",    desc = "Create New" },
    { "<leader>wq", ":q<CR>",      desc = "Close" },
    { "<leader>wQ", ":qall<CR>",   desc = "Close all" },
    { "<leader>ws", ":split<CR>",  desc = "Split" },
    { "<leader>wv", ":vsplit<CR>", desc = "Vertical split" },
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
    { "q",          "<nop>" },
    { "<esc><esc>", ":noh<CR>" },
    { "<leader>Q",  ":qa<CR>",                           desc = "Close Neovim" },
    { "<leader>w",  ":w!<CR>",                           desc = "Save" },
    { "H",          ":bprev<CR>",                        desc = "Previous Buffer" },
    { "L",          ":bnext<CR>",                        desc = "Previous Buffer" },
    { "<BS>",       ":b#<CR>",                           desc = "Last Buffer" },
    { "<F5>",       ":update<CR> :source<CR>",           desc = "Source file", },
    { "gd",         ":lua vim.lsp.buf.definition()<cr>", desc = "Go to definition" },
    { "<F5>",       ":restart<CR>",                      desc = "Restart" },
  },
  {
    mode = "i",
    { "jk",    "<esc>" },
    { "kj",    "<esc>" },
    { "<C-s>", "<esc>:update<CR>a", desc = "Save" },
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
