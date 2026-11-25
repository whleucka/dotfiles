-- nvim-treesitter's `main` branch only installs parsers and queries; turning
-- them on per buffer is ours to do. treesitter-modules.nvim used to rebuild the
-- old master-branch module system for that -- on Nvim 0.12 it is this file.
local M = {}

local ensure_installed = {
  'php',
  -- queries/php_only/injections.scm injects phpdoc into every (comment) and
  -- regex into preg_* arguments. Auto-install only ever fetches the parser for
  -- the buffer's own filetype, so injected languages have to be listed here or
  -- docblocks and patterns render as flat comment/string text.
  'phpdoc',
  'regex',
  'bash',
  'c',
  'cpp',
  'css',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'html',
  'json', -- composer.json
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'rust',
  'sql',
  'javascript',
  -- twig highlights {% %} itself and injects html into (content); it is what
  -- replaced coercing .twig buffers to filetype=html.
  'twig',
  'xml', -- phpunit.xml
}

local function has_query(lang, name)
  return #vim.treesitter.query.get_files(lang, name) > 0
end

-- <Enter> starts a selection on the node under the cursor and grows it to the
-- parent; <BS> walks back down the same path. Nvim's own an/in do the same
-- from visual mode -- these are the old treesitter-modules keys on top.
local function map_selection(buf)
  local function map(mode, lhs, target, desc)
    vim.keymap.set(mode, lhs, function()
      vim.treesitter.select(target, vim.v.count1)
    end, { buffer = buf, silent = true, desc = desc })
  end
  map("n", "<Enter>", "parent", "Select treesitter node")
  map("x", "<Enter>", "parent", "Grow selection to parent node")
  map("x", "<BS>", "child", "Shrink selection")
end

---@return boolean attached false when there is no parser for `lang`
local function attach(buf, lang)
  if not vim.treesitter.language.add(lang) then
    return false
  end
  if has_query(lang, "highlights") then
    vim.treesitter.start(buf, lang)
  end
  if has_query(lang, "indents") then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  -- 'foldmethod' is already "expr" globally (core.options). Local to the
  -- buffer-in-window, so the fold expression doesn't follow the window to the
  -- next buffer it shows.
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end
  map_selection(buf)
  return true
end

-- Languages auto-install has been tried for, so a filetype with no parser
-- upstream isn't looked up again on every buffer.
local attempted = {}

local function on_filetype(buf, filetype)
  local lang = vim.treesitter.language.get_lang(filetype)
  if not lang or attach(buf, lang) or attempted[lang] then
    return
  end
  attempted[lang] = true
  local ts = require("nvim-treesitter")
  if not vim.list_contains(ts.get_available(), lang) then
    return
  end
  ts.install(lang):await(function(err)
    if err then
      return
    end
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == filetype then
        attach(buf, lang)
      end
    end)
  end)
end

function M.setup()
  -- Async, and a no-op for parsers already installed.
  require("nvim-treesitter").install(ensure_installed)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter-attach", { clear = true }),
    callback = function(args)
      on_filetype(args.buf, args.match)
    end,
  })

  -- Buffers that got their filetype before this loaded (when it was first
  -- pulled in by a :TS* command or as render-markdown's dependency).
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.bo[buf].filetype
    if vim.api.nvim_buf_is_loaded(buf) and ft ~= "" then
      on_filetype(buf, ft)
    end
  end
end

return M
