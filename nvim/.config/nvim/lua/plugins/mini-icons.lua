return {
  'nvim-mini/mini.icons',
  config = function()
    require('mini.icons').setup()
    -- Provide nvim-web-devicons shim for plugins that only support it
    MiniIcons.mock_nvim_web_devicons()
  end,
}
