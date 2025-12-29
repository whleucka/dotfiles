return {
  function()
    local processed_specs = {}

    local THEME_FILE = os.getenv("HOME") .. "/.config/omarchy/current/theme/neovim.lua"
    if vim.fn.filereadable(THEME_FILE) == 0 then
      local spec = require("omarchy.default")
      table.insert(processed_specs, spec)
      return processed_specs
    end

    local ok, theme_chunk = pcall(loadfile, THEME_FILE)
    if not ok or not theme_chunk then
      return nil
    end

    local ok_run, specs = pcall(theme_chunk)
    if not ok_run or not specs then
      return nil
    end

    local lazy_spec = specs[2]

    for _, spec in ipairs(specs) do
      if spec[1] ~= "LazyVim/LazyVim" then
        spec.priority = 1000
        spec.config = function()
          vim.cmd.colorscheme(lazy_spec.opts.colorscheme)
          require("omarchy.watcher").setup()
        end
        table.insert(processed_specs, spec)
      end
    end

    return processed_specs
  end
}
