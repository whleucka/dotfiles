-- General Essentials
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Relative line numbers for fast navigation
vim.opt.mouse = 'a'               -- Enable mouse support
vim.opt.clipboard = 'unnamedplus' -- System clipboard access
vim.opt.swapfile = false          -- No swap files (less clutter)
vim.opt.backup = false            -- No backups (Git got you)
vim.opt.undofile = true           -- Persistent undo history

-- Smarter Tabs & Indenting
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.shiftwidth = 4     -- Indent size
vim.opt.tabstop = 4        -- Display width of a tab
vim.opt.smartindent = true -- Auto-indent new lines
vim.opt.autoindent = true  -- Copy indent from current line

-- UI/UX Improvements
vim.opt.cmdheight = 0         -- No command height
vim.opt.cursorline = true     -- Highlight current line
vim.opt.termguicolors = true  -- 24-bit color support
vim.opt.guicursor = "a:"
vim.opt.signcolumn = 'yes'    -- Always show signcolumn (gutter)
vim.opt.scrolloff = 8         -- Context lines above/below cursor
vim.opt.sidescrolloff = 8     -- Context on sides for horizontal movement
vim.opt.wrap = false          -- Don't wrap long lines
vim.opt.winborder = "rounded" -- Rounded borders
vim.cmd("set completeopt=menuone,noinsert,noselect")

-- Searching and Navigation
vim.opt.ignorecase = true    -- Ignore case when searching
vim.opt.smartcase = true     -- Case-sensitive if uppercase used
vim.opt.incsearch = true     -- Search as you type
vim.opt.hlsearch = true      -- Highlight matches
vim.opt.inccommand = 'split' -- Live preview of substitute

-- File and Buffer Management
vim.opt.splitbelow = true -- Horizontal splits below
vim.opt.splitright = true -- Vertical splits to the right
vim.opt.hidden = true     -- Keep buffers open in background
vim.opt.confirm = true    -- Confirm to save before closing

-- Performance
vim.opt.updatetime = 200 -- Faster CursorHold, good for LSP
vim.opt.timeoutlen = 300 -- Shorter delay for mapped sequences

-- Aesthetics
vim.opt.showmode = false                -- Don’t show mode (use statusline plugin)
vim.opt.laststatus = 3                  -- Global statusline (Neovim 0.7+)
vim.opt.fillchars:append { eob = ' ' }  -- No ~ at end of buffers

-- Extra Ninja Options
vim.opt.lazyredraw = true           -- Faster macro execution
vim.opt.virtualedit = 'block'       -- Allow cursor beyond EOL in visual block
vim.opt.whichwrap:append('<,>,[,]') -- Left/right move across lines

-- Folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
vim.opt.foldenable = false

vim.wo.winbar = ""

-- Neovim 0.12+
vim.opt.diffopt:append('linematch:60') -- Better diffs with linematch algorithm
vim.loader.enable()                    -- Fast startup via Lua module caching
