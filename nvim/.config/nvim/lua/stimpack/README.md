# 😎💉⚡ STIMPACK

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/8e35f01c-4182-4aab-a64b-ef5ba6117721" />

A simple Neovim plugin manager wrapper around `vim.pack`, providing a streamlined way to manage your plugins with support for lazy loading.

## Commands

- `:StimSync`: Updates all installed plugins. This command is equivalent to running `vim.pack.update()`.
- `:StimDelete <plugin-name>`: Deletes a specific plugin by its name. For example, `:StimDelete nvim-tree.lua`.
- `:StimUpdate <plugin-name>`: Updates a specific plugin by its name. For example, `:StimUpdate plenary.nvim`.
- `:StimGet <plugin-name>`: Displays detailed information about a specific plugin, such as its path, active status, and revision.
- `:StimNuke`: **WARNING:** This command will delete *all* Neovim plugins from your disk. Use with extreme caution.

## Plugin Specification

Plugins are defined as `.lua` files in the `lua/plugins` directory. Each file returns a table that represents the plugin's specification.

Here is an example of a plugin spec with all available options:

```lua
return {
  -- The plugin's repository URL (required).
  -- Can be a short form like "owner/repo".
  "owner/repo-name",

  -- The name of the plugin (optional).
  -- If not provided, it will be inferred from the URL.
  name = "my-plugin-name",

  -- Pin a specific version (tag, branch, or commit hash) (optional).
  version = "v1.2.3",

  -- A list of dependencies for this plugin (optional).
  dependencies = {
    "another/dependency",
  },

  -- A build command to run on install or update (optional).
  -- Can be a string or a function.
  build = "make", -- or "npm install" or "cargo build --release"

  -- A flag to enable or disable the plugin (optional).
  -- Can be a boolean or a function that returns a boolean.
  -- Defaults to true. If false, the plugin will not be loaded.
  enabled = true,

  -- Configuration function to run after the plugin is loaded (optional).
  config = function()
    require("my-plugin-name").setup({
      -- plugin options
    })
  end,

  -- Lazy-loading event(s) (optional).
  -- The plugin will be loaded when any of these autocommand events are triggered.
  event = { "BufReadPost", "InsertEnter" }, -- or "VeryLazy"

  -- Lazy-loading on specific filetypes (optional).
  ft = { "go", "python", "lua" },

  -- Lazy-loading on command (optional).
  -- Creates a user command that will load the plugin when executed.
  cmd = { "MyPluginCommand", "AnotherCommand" },

  -- Explicitly mark a plugin as lazy (optional).
  -- Useful if other mechanisms don't cover the lazy-loading needs.
  lazy = true,

  -- Key mappings for which-key.nvim (optional).
  -- Can be a table or a function that returns a table.
  -- Using a function is required if you need to `require` the plugin's modules.
  keys = function()
    return {
      { "<leader>p", "<cmd>MyPluginCommand<cr>", desc = "My Plugin" },
    }
  end,
}
```
