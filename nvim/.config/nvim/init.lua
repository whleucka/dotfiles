vim.g.start_time = vim.fn.reltime()

require("stimpack").setup({
  additional_specs = {
    function()
      local THEME_FILE = os.getenv("HOME") .. "/.config/omarchy/current/theme/neovim.lua"
      if vim.fn.filereadable(THEME_FILE) == 0 then
        return nil
      end
      local ok, theme_chunk = pcall(loadfile, THEME_FILE)
      if not ok or not theme_chunk then
        return nil
      end
      local ok_run, theme_specs = pcall(theme_chunk)
      if not ok_run or not theme_specs then
        return nil
      end

      local processed_specs = {}
      for _, spec in ipairs(theme_specs) do
        if spec[1] == "LazyVim/LazyVim" then
          local new_spec = vim.deepcopy(spec)
          new_spec.install = false
          table.insert(processed_specs, new_spec)
        else
          table.insert(processed_specs, spec)
        end
      end
      return processed_specs
    end,
  },
})

require("core.omarchy")
require("core.globals")
require("core.options")
require("core.autocmd")
require("core.lsp")
