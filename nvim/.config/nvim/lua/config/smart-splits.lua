-- Nav/resize here apply only OUTSIDE herdr; inside a herdr pane herdr-splits.nvim
-- owns those keys (see plugins/smart-splits.lua and plugins/herdr-splits.lua).
-- smart-splits v3 config layout, see :h smart-splits-configuration
return {
  -- Ignored buffer types / filetypes (shared by resize and move)
  ignored_buftypes = {
    'nofile',
    'quickfix',
    'prompt',
  },
  ignored_filetypes = { 'NvimTree' },
  resize = {
    -- the default number of lines/columns to resize by at a time
    amount = 3,
    -- ignore these autocmd events (via :h eventignore) while resizing
    ignored_events = {
      'BufEnter',
      'WinEnter',
    },
  },
  move = {
    -- Desired behavior when your cursor is at an edge and you
    -- are moving towards that same edge:
    -- 'wrap' => Wrap to opposite side
    -- 'split' => Create a new split in the desired direction
    -- 'stop' => Do nothing
    -- function => You handle the behavior yourself
    -- Unified directional navigation: at the nvim split's edge there is no
    -- multiplexer left to walk, so hand off to the Hyprland window.
    at_edge = function(ctx)
      local dir = ({ left = 'l', right = 'r', up = 'u', down = 'd' })[ctx.direction]
      vim.fn.system({ os.getenv('HOME') .. '/.config/hypr/scripts/focus', dir })
    end,
    -- when moving cursor between splits left or right,
    -- place the cursor on the same row of the *screen*
    same_row = false,
  },
  swap = {
    -- whether the cursor should follow the buffer when swapping buffers
    move_cursor = false,
  },
  -- No mux.backend: herdr is the multiplexer and smart-splits has no herdr
  -- support, so nav stops at the nvim edge and move.at_edge takes it from there.
  log = {
    -- one of: 'trace'|'debug'|'info'|'warn'|'error'|'fatal'
    level = 'info',
  },
}
