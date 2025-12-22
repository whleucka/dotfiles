# 😎💉⚡ STIMPACK

A simple Neovim plugin manager wrapper around `vim.pack`, providing a streamlined way to manage your plugins with support for lazy loading.

## Commands

- `:StimSync`: Updates all installed plugins and runs their build commands if defined. This command internally calls `vim.pack.update()`.
- `:StimDelete <plugin-name>`: Deletes a specific plugin by its name. For example, `:StimDelete nvim-tree.lua`.
- `:StimUpdate <plugin-name>`: Updates a specific plugin by its name and runs its build command if defined. This command internally calls `vim.pack.update()`.
- `:StimGet <plugin-name>`: Displays detailed information about a specific plugin, such as its path, active status, and revision.
- `:StimNuke`: **WARNING:** This command will delete *all* Neovim plugins from your disk. Use with extreme caution.
- `:StimStatus`: Displays a list of all loaded plugins, indicating whether they are local (development) plugins or providing the short commit hash for installed plugins. It does not currently track plugin load times.

## Setup

```lua
require("stimpack").setup()
```

## Default Config

```lua
{
  paths = {
    plugins = vim.fn.stdpath("config") .. "/lua/plugins",
  }
}
```

## Plugin Specification

Plugins are defined as `.lua` files in the `lua/plugins` directory. Each file returns a table that represents the plugin's specification.

Here is an example of a plugin spec with all available options:

```lua
return {
  -- The plugin's repository URL (required).
  -- Can be a short form like "owner/repo".
  "owner/repo-name",

  -- Load a local plugin from the specified directory (optional).
  -- This is useful for plugin development.
  -- If this key is set, the plugin will be loaded from this path
  -- instead of being fetched from a remote repository.
  dir = "/path/to/my/local/plugin",

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
  -- Can be a string (shell command or Neovim command prefixed with ':') or a function.
  build = "make", -- or ":TSUpdate" or "npm install" or "cargo build --release"

  -- A flag to enable or disable the plugin (optional).
  -- Can be a boolean or a function that returns a boolean.
  -- Defaults to true. If false, the plugin will not be loaded.
  enabled = true,

  -- Specify the main module of a plugin (optional).
  -- This is useful if the plugin's main module is not the same as its name
  -- (e.g. 'plugin-nvim' needs to be required as 'plugin').
  -- When using `opts`, this module will be used for the setup function.
  main = "plugin",

  -- Plugin options table (optional).
  -- A simpler alternative to the `config` function. If this key is provided,
  -- stimpack will automatically call the plugin's `setup` function with this table.
  -- If you also provide a `config` function, the `opts` table will be ignored.
  opts = {
    -- plugin options here
  },

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

**Note:** If neither `config` nor `opts` are specified for a plugin, `stimpack` will automatically attempt to call the plugin's `setup` function with an empty table (e.g., `require("plugin-name").setup({})`). It determines the `plugin-name` by first checking for a `main` key in your spec, and if not found, by stripping `[-.]nvim$` from the plugin's repository name.
