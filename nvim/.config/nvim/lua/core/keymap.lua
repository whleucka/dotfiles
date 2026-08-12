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
      "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Action"
    },
    {
      "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format"
    },
    {
      "<leader>cr", function() vim.lsp.buf.rename() end, desc = "Rename symbol"
    },
    {
      "<leader>cd", function() vim.diagnostic.open_float() end, desc = "Line diagnostics"
    },
    {
      "<leader>cs", function() vim.lsp.buf.signature_help() end, desc = "Signature help"
    },
    {
      "<leader>cl", function() vim.diagnostic.setloclist() end, desc = "Diagnostics to loclist"
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
    {
      "<leader>bq",
      -- Plain :bd closes the *window* when it isn't the last one (e.g. with a
      -- docked split like mantis). mini.bufremove deletes the buffer while
      -- keeping the window layout intact.
      function() require("mini.bufremove").delete(0, false) end,
      desc = "Close",
    },
    {
      "<leader>bQ",
      function()
        local bufremove = require('mini.bufremove')

        -- Get a list of all currently open buffers
        local buffers = vim.api.nvim_list_bufs()

        for _, bufnr in ipairs(buffers) do
          -- Only delete the buffer if it is listed/valid
          if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
            -- Change false to true if you want to force-delete unsaved buffers
            bufremove.delete(bufnr, false) 
          end
        end
      end,
      desc = "Close",
    },
    { "<leader>bn", ":bnext<CR>",  desc = "Next" },
    { "<leader>bp", ":bprev<CR>",  desc = "Prev" },
    { "<leader>bf", ":bfirst<CR>", desc = "First" },
    { "<leader>bl", ":blast<CR>",  desc = "Last" },
    {
      "<leader>bo",
      function()
        local cur = vim.api.nvim_get_current_buf()
        for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
          if b.bufnr ~= cur then vim.cmd("bd " .. b.bufnr) end
        end
      end,
      desc = "Close Others",
    },
    {
      "<leader>bH",
      function()
        local cur = vim.api.nvim_get_current_buf()
        for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
          if b.bufnr == cur then break end
          vim.cmd("bd " .. b.bufnr)
        end
      end,
      desc = "Close Left",
    },
    {
      "<leader>bL",
      function()
        local cur = vim.api.nvim_get_current_buf()
        local seen = false
        for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
          if seen then vim.cmd("bd " .. b.bufnr) end
          if b.bufnr == cur then seen = true end
        end
      end,
      desc = "Close Right",
    },
  },
  {
    { "q",          "<nop>" },
    { "<esc><esc>", ":noh<CR>" },
    { "<leader>q",  function() require("mini.bufremove").delete(0, false) end, desc = "Close buffer" },
    { "<leader>Q",  ":qa<CR>",                                                 desc = "Close Neovim" },
    { "<leader>w",  ":w!<CR>",                                                 desc = "Save" },
    { "H",          ":bprev<CR>",                                              desc = "Previous Buffer" },
    { "L",          ":bnext<CR>",                                              desc = "Previous Buffer" },
    { "gd",         ":lua vim.lsp.buf.definition()<cr>",                       desc = "Go to definition" },
    { "gD",         ":lua vim.lsp.buf.declaration()<cr>",                      desc = "Go to declaration" },
    { "gi",         ":lua vim.lsp.buf.implementation()<cr>",                   desc = "Go to implementation" },
    { "gr",         ":lua vim.lsp.buf.references()<cr>",                       desc = "Go to references" },
    { "gt",         ":lua vim.lsp.buf.type_definition()<cr>",                  desc = "Go to type definition" },
    { "K",          ":lua vim.lsp.buf.hover()<cr>",                            desc = "Hover documentation" },
    { "<F5>",       ":restart<CR>",                                            desc = "Restart" },
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
