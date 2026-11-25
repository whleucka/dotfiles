-- Leader, etc
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Disable unused remote plugin providers (silences :checkhealth warnings)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Startup plugins that go unused here (~2-3ms). mini.files is the explorer
-- (netrw); gx is vim.ui.open, not netrw; editing is local or over sshfs, never
-- scp:// or inside .gz/.tar/.zip. rplugin is only for remote plugins, and every
-- provider above is off. fzf.vim is Arch's fzf package dropping its Vim
-- plugin on the 'rtp' via /usr/share/vim/vimfiles -- mini.pick is the picker.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_fzf = 1
