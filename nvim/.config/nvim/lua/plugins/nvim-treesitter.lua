vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "v0.10.0",
  },
})

local config = require("config.treesitter")
require("nvim-treesitter.configs").setup(config)

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.cfml = {
  install_info = {
    url = "https://github.com/cfmleditor/tree-sitter-cfml",
    files = {"cfml/src/parser.c"},
    branch = "master",
  },
  filetype = "cfml",
}

vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
    callback = function(event)
        if event.data.kind == 'update' then
            vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
            ---@diagnostic disable-next-line: param-type-mismatch
            local ok = pcall(vim.cmd, 'TSUpdate')
            if ok then
                vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
            else
                vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
            end
        end
    end,
})

