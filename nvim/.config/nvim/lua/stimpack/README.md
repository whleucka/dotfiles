# 😎💉⚡ STIMPACK

A simple Neovim plugin manager wrapper around `vim.pack`, providing a streamlined way to manage your plugins with support for lazy loading.

## Commands

- `:StimSync[!]`: Updates all installed plugins and runs their build commands if defined. This command internally calls `vim.pack.update()`, and also automatically runs `:StimClean` first. Use `:StimSync!` to skip confirmation prompts.
- `:StimDelete <plugin-name>`: Deletes a specific plugin by its name. For example, `:StimDelete nvim-tree.lua`.
- `:StimUpdate[!] <plugin-name>`: Updates a specific plugin by its name and runs its build command if defined. This command internally calls `vim.pack.update()`. Use `:StimUpdate!` to skip confirmation prompts.
- `:StimGet <plugin-name>`: Displays detailed information about a specific plugin, such as its path, active status, and revision.
- `:StimBuild <plugin-name>`: Runs the `build` step for a specific plugin on demand (without updating it). Completion is restricted to plugins that define a `build`. Useful for re-running things like `:TSUpdate` or `make` without performing a sync.
- `:StimNuke`: **WARNING:** This command will delete *all* Neovim plugins from your disk. Use with extreme caution.
- `:StimClean[!]`: Removes any installed plugins that are no longer defined in your `stimpack` plugin specifications (i.e., orphaned plugins). Prompts for confirmation before deleting; use `:StimClean!` to skip the prompt.
- `:StimProfile`: Displays a comprehensive performance profile of your Neovim setup. This includes:
    *   **Stimpack Configuration Time**: How long it took Stimpack to configure itself.
    *   **Total Plugin Load Time**: The sum of individual load times for all plugins managed by Stimpack.
    *   **UI Ready Time**: The automated time it took for Neovim's UI to be considered ready (measured on `VimEnter`).
    *   **Plugin Tree with Load Times**: A hierarchical view of all loaded plugins and their dependencies, showing the short commit hash of their current revision (or "local" for local plugins) and their individual load times.

## Setup

```lua
require("stimpack").setup{}
```

## Default Config

Configure `paths.plugins` to reference the directory containing your plugin specification files.

```lua
{
  paths = {
    plugins = vim.fn.stdpath("config") .. "/lua/plugins",
  },

  -- Optional list of functions that return additional spec tables.
  -- Each function is called during setup and its returned specs are merged
  -- in alongside the ones loaded from `paths.plugins`. Useful for injecting
  -- specs from other modules without dropping a file in the plugins dir.
  -- additional_specs = {
  --   function() return require("my.extra.specs") end,
  -- },
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

  -- A flag to explicitly control plugin installation (optional).
  -- Defaults to `true`. If set to `false`, the plugin will *not* be physically
  -- installed (i.e., `vim.pack.add` will not be called for it).
  -- However, its `config` function and `opts` will still be processed, making it
  -- useful for "virtual" plugins or configurations that don't correspond to
  -- an installable repository. Plugins with `install = false` will be ignored
  -- by `:StimClean` when identifying orphaned plugins.
  install = true,

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

  -- Load priority (optional, defaults to 50).
  -- Specs are sorted in descending order of priority before loading, so
  -- higher numbers load earlier. Use this for things like colorschemes or
  -- plugins other plugins depend on at startup.
  priority = 100,

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
