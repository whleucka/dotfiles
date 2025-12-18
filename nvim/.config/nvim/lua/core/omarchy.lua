--[[
 ██████╗ ███╗   ███╗ █████╗ ██████╗  ██████╗██╗  ██╗██╗   ██╗
██╔═══██╗████╗ ████║██╔══██╗██╔══██╗██╔════╝██║  ██║╚██╗ ██╔╝
██║   ██║██╔████╔██║███████║██████╔╝██║     ███████║ ╚████╔╝ 
██║   ██║██║╚██╔╝██║██╔══██║██╔══██╗██║     ██╔══██║  ╚██╔╝  
╚██████╔╝██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╗██║  ██║   ██║   
 ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   
 Omarchy dynamic theme loader + watcher
 Created by: william.hleucka@gmail.com
]]--
local uv = vim.loop

-- Direct path to your theme file
local THEME_FILE = os.getenv("HOME") .. "/.config/omarchy/current/theme/neovim.lua"

-- Fallback to Catppuccin
local function fallback_theme()
  vim.cmd.colorscheme "catppuccin"
  vim.cmd [[
    hi Normal guibg=NONE ctermbg=NONE
    hi NormalNC guibg=NONE ctermbg=NONE
    hi SignColumn guibg=NONE ctermbg=NONE
    hi LineNr guibg=NONE ctermbg=NONE
    hi EndOfBuffer guibg=NONE ctermbg=NONE
  ]]
end

-- Safe load of theme.lua
local function load_theme()
  local ok, theme_chunk = pcall(loadfile, THEME_FILE)
  if not ok or not theme_chunk then
    fallback_theme()
    return nil
  end

  local ok_run, theme = pcall(theme_chunk)
  if not ok_run or not theme then
    fallback_theme()
    return nil
  end

  return theme
end

-- Apply theme and re-sync UI plugins
local known_schemes = {
  tokyonight = "folke/tokyonight.nvim",
  catppuccin = "catppuccin/nvim",
}

local function apply_theme()
  local theme = load_theme()
  if not theme then return end

  local specs = vim.islist(theme) and theme or { theme }

  local colorscheme
  local applied_via_config = false

  for _, spec in ipairs(specs) do
    local repo = spec[1]
    if type(repo) == "string" and not repo:match("LazyVim/LazyVim") then
      if spec.dependencies then
        for _, dep in ipairs(spec.dependencies) do
          local dep_src = "https://github.com/" .. dep
          vim.pack.add({ { src = dep_src } })
        end
      end

      local src = "https://github.com/" .. repo
      vim.pack.add({ { src = src } })

      if type(spec.config) == "function" then
        pcall(spec.config)
        applied_via_config = true
      elseif spec.opts and spec.opts.colorscheme then
        colorscheme = spec.opts.colorscheme
      end
    elseif repo == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
      colorscheme = spec.opts.colorscheme
    end
  end

  if colorscheme then
    local base = colorscheme:match("^[^%-]+")
    local special_repo = known_schemes[base]
    if special_repo then
      vim.pack.add({ { src = "https://github.com/" .. special_repo } })
    end
  end

  vim.defer_fn(function()
    if not applied_via_config then
      if colorscheme then
        local ok_cs, err = pcall(vim.cmd.colorscheme, colorscheme)
        if not ok_cs then
          vim.notify("Omarchy: failed to apply " .. colorscheme .. ": " .. err, vim.log.levels.ERROR)
          fallback_theme()
          return
        end
      else
        vim.notify("Omarchy: no colorscheme found, using fallback", vim.log.levels.WARN)
        fallback_theme()
      end
    end
  end, 50)
end

-- Watcher logic
_G._omarchy_state = _G._omarchy_state or { file_poll = nil }
local W = _G._omarchy_state

local function restart_file_poll()
  if W.file_poll then
    pcall(W.file_poll.stop, W.file_poll)
    pcall(W.file_poll.close, W.file_poll)
  end
  W.file_poll = uv.new_fs_poll()
  W.file_poll:start(THEME_FILE, 500, function(err, prev, curr)
    if err then
      vim.schedule(function()
        vim.notify("Omarchy file poll error: " .. err, vim.log.levels.ERROR)
      end)
      return
    end
    if not prev or not curr or prev.mtime.sec ~= curr.mtime.sec or prev.size ~= curr.size then
      vim.schedule(apply_theme)
    end
  end)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if W.file_poll then pcall(W.file_poll.stop, W.file_poll) end
  end,
})

if vim.fn.filereadable(THEME_FILE) == 1 then
  apply_theme()
  restart_file_poll()
else
  fallback_theme()
end
