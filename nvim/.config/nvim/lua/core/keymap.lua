local folds_enabled = vim.opt.foldenable
local current_colorscheme = vim.g.colors_name

local function is_transparent()
  local bg = vim.api.nvim_get_hl(0, { name = "Normal" }).background
  return bg == nil
end

local transparent_enabled = is_transparent()

return {
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
  },
  {
    "<leader>u",
    group = "UI",
    { "<leader>un", ":set relativenumber!<CR> :set number!<CR>", desc = "Toggle line numbers" },
    { "<leader>ur", ":set relativenumber!<CR>",                  desc = "Toggle relative numbers" },
    { "<leader>uw", ":set wrap!<CR>",                            desc = "Toggle line wrap" },
    { "<leader>us", ":set spell!<CR>",                           desc = "Toggle spell check" },
    { "<leader>ul", ":set list!<CR>",                            desc = "Toggle invisible characters" },
    { "<leader>uh", ":set hlsearch!<CR>",                        desc = "Toggle search highlight" },
    { "<leader>ui", ":set cursorline!<CR>",                      desc = "Toggle cursorline" },
    {
      "<leader>uc",
      function()
        if vim.wo.colorcolumn == "" then
          vim.wo.colorcolumn = "80"
        else
          vim.wo.colorcolumn = ""
        end
      end,
      desc = "Toggle colorcolumn"
    },
    {
      "<leader>ud",
      function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      end,
      desc = "Toggle diagnostics"
    },
    {
      "<leader>ub",
      function()
        if vim.o.background == "dark" then
          vim.o.background = "light"
        else
          vim.o.background = "dark"
          transparent_enabled = true
          vim.cmd("hi! Normal guibg=NONE ctermbg=NONE")
          vim.cmd("hi! NormalNC guibg=NONE ctermbg=NONE")
          vim.cmd("hi! SignColumn guibg=NONE ctermbg=NONE")
          vim.cmd("hi! LineNr guibg=NONE ctermbg=NONE")
          vim.cmd("hi! EndOfBuffer guibg=NONE ctermbg=NONE")
        end
      end,
      desc = "Toggle light/dark background"
    },
    {
      "<leader>ut",
      function()
        transparent_enabled = not transparent_enabled
        if transparent_enabled then
          vim.cmd("hi! Normal guibg=NONE ctermbg=NONE")
          vim.cmd("hi! NormalNC guibg=NONE ctermbg=NONE")
          vim.cmd("hi! SignColumn guibg=NONE ctermbg=NONE")
          vim.cmd("hi! LineNr guibg=NONE ctermbg=NONE")
          vim.cmd("hi! EndOfBuffer guibg=NONE ctermbg=NONE")
        else
          vim.cmd("hi clear Normal")
          vim.cmd("hi clear NormalNC")
          vim.cmd("hi clear SignColumn")
          vim.cmd("hi clear LineNr")
          vim.cmd("hi clear EndOfBuffer")
          vim.cmd.colorscheme(current_colorscheme)
        end
      end,
      desc = "Toggle transparency"
    },
    {
      "<leader>uf",
      function()
        folds_enabled = not folds_enabled
        if folds_enabled then
          vim.wo.foldenable = false
        else
          vim.wo.foldenable = true
        end
      end,
      desc = "Toggle folds"
    },
    { "<leader>uS", ":set showtabline=0<CR>", desc = "Hide tabline" },
    { "<leader>uT", ":set showtabline=2<CR>", desc = "Show tabline" },

    {
      "<leader>ug",
      function()
        vim.o.signcolumn = (vim.o.signcolumn == "yes" and "no") or "yes"
      end,
      desc = "Toggle signcolumn"
    },

    {
      "<leader>uH",
      function()
        vim.o.laststatus = (vim.o.laststatus == 3 and 2) or 3
      end,
      desc = "Toggle global statusline"
    },

    {
      "<leader>uB",
      function()
        vim.o.scrolloff = (vim.o.scrolloff == 0 and 8) or 0
      end,
      desc = "Toggle scrolloff padding"
    },
    { "<leader>ua", ":set autoindent!<CR>", desc = "Toggle autoindent" },
    { "<leader>uP", ":set paste!<CR>",      desc = "Toggle paste mode" },
    { "<leader>ue", ":set expandtab!<CR>",  desc = "Toggle expandtab vs tabs" },
    {
      "<leader>uz",
      function()
        vim.wo.conceallevel = (vim.wo.conceallevel == 0 and 2) or 0
      end,
      desc = "Toggle conceal level"
    },

    {
      "<leader>ux",
      function()
        vim.o.relativenumber = false
        vim.o.number = false
        vim.o.signcolumn = "no"
        vim.o.foldenable = false
        vim.o.cursorline = false
        vim.o.list = false
      end,
      desc = "Zen mode lite"
    },
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
