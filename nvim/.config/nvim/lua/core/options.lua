-- General Essentials
vim.o.number = true             -- Show line numbers
vim.o.relativenumber = true     -- Relative line numbers for fast navigation
vim.o.mouse = 'a'               -- Enable mouse support
vim.o.clipboard = 'unnamedplus' -- System clipboard access
vim.o.swapfile = false          -- No swap files (less clutter)
vim.o.backup = false            -- No backups (Git got you)
vim.o.undofile = true           -- Persistent undo history

-- Smarter Tabs & Indenting
vim.o.expandtab = true   -- Use spaces instead of tabs
vim.o.shiftwidth = 4     -- Indent size
vim.o.tabstop = 4        -- Display width of a tab
vim.o.smartindent = true -- Auto-indent new lines
vim.o.autoindent = true  -- Copy indent from current line

-- UI/UX Improvements
vim.o.cmdheight = 0         -- No command height
vim.o.cursorline = true     -- Highlight current line
vim.o.termguicolors = true  -- 24-bit color support
vim.o.guicursor = "a:"
vim.o.signcolumn = 'yes'    -- Always show signcolumn (gutter)
vim.o.numberwidth = 4       -- Room for 3-digit relative numbers, no jitter on scroll
vim.o.scrolloff = 8         -- Context lines above/below cursor
vim.o.sidescrolloff = 8     -- Context on sides for horizontal movement
vim.o.wrap = false          -- Don't wrap long lines
vim.o.winborder = "rounded" -- Rounded borders
vim.cmd("set completeopt=menuone,noinsert,noselect")

-- Searching and Navigation
vim.o.ignorecase = true    -- Ignore case when searching
vim.o.smartcase = true     -- Case-sensitive if uppercase used
vim.o.incsearch = true     -- Search as you type
vim.o.hlsearch = true      -- Highlight matches
vim.o.inccommand = 'split' -- Live preview of substitute

-- File and Buffer Management
vim.o.splitbelow = true -- Horizontal splits below
vim.o.splitright = true -- Vertical splits to the right
vim.o.hidden = true     -- Keep buffers open in background
vim.o.confirm = true    -- Confirm to save before closing

-- Performance
vim.o.updatetime = 200 -- Faster CursorHold, good for LSP
vim.o.timeoutlen = 300 -- Shorter delay for mapped sequences

-- Whitespace
vim.o.list = true
-- leadmultispace pattern is shiftwidth-wide, so indent guides land on tab stops
vim.o.listchars = "tab:» ,leadmultispace:·   ,trail:·,nbsp:+,extends:›,precedes:‹"

-- Aesthetics
vim.o.showmode = false                -- Don’t show mode (use statusline plugin)
vim.o.laststatus = 3                  -- Global statusline (Neovim 0.7+)
vim.opt.fillchars:append({              -- vim.o has no :append, must use vim.opt
  eob = " ",                            -- No ~ past end of buffer
  vert = "│",                            -- Thin split separator
  horiz = "─",
  fold = " ",
  foldopen = "▾",
  foldclose = "▸",
  foldsep = " ",
  diff = "╱",
})

-- Extra Ninja Options
vim.o.lazyredraw = true           -- Faster macro execution
vim.o.virtualedit = 'block'       -- Allow cursor beyond EOL in visual block
vim.opt.whichwrap:append('<,>,[,]') -- Left/right move across lines

-- Folds
vim.o.foldmethod = "expr"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 1
vim.o.foldenable = false

vim.wo.winbar = ""

-- Spelling
vim.o.spelllang = 'en_ca'

-- Auto reload when file changes
vim.o.autoread = true

-- Neovim 0.12+
-- linematch is on by default at 40; drop the default before raising the budget so
-- diffopt doesn't carry two conflicting linematch entries
vim.opt.diffopt = vim.tbl_filter(function(o)
  return not vim.startswith(o, 'linematch:')
end, vim.opt.diffopt:get())
vim.opt.diffopt:append('linematch:60') -- Better diffs with linematch algorithm
vim.loader.enable()                    -- Fast startup via Lua module caching
