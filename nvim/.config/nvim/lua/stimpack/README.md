# 😎💉⚡ STIMPACK

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/8e35f01c-4182-4aab-a64b-ef5ba6117721" />

A simple Neovim plugin manager wrapper around `vim.pack`, providing a streamlined way to manage your plugins with support for lazy loading.

## Commands

- `:StimSync`: Updates all installed plugins. This command is equivalent to running `vim.pack.update()`.
- `:StimDelete <plugin-name>`: Deletes a specific plugin by its name. For example, `:StimDelete nvim-tree.lua`.
- `:StimUpdate <plugin-name>`: Updates a specific plugin by its name. For example, `:StimUpdate plenary.nvim`.
- `:StimGet <plugin-name>`: Displays detailed information about a specific plugin, such as its path, active status, and revision.
- `:StimNuke`: **WARNING:** This command will delete *all* Neovim plugins from your disk. Use with extreme caution.
