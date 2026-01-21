return {
  function()
    local processed_specs = {}
    local theme_file = require("omarchy.config").theme_file

    if vim.fn.filereadable(theme_file) == 0 then
      local spec = require("omarchy.config").fallback_theme
      table.insert(processed_specs, spec)
      return processed_specs
    end

    local ok, theme_chunk = pcall(loadfile, theme_file)
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
          lazy_spec.opts.dim_inactive = true
          require("omarchy.watcher").setup()
        end
        table.insert(processed_specs, spec)
      end
    end

    return processed_specs
  end
}
