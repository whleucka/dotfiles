-- Renders ANSI escape sequences in a buffer as real highlights.
-- Used by ftplugin/ansi.lua for herdr scrollback dumps
-- (~/.config/herdr/scripts/scrollback) and any other captured terminal output.
--
-- The ftplugin `packadd`s and configures this itself: nvim's built-in
-- filetypeplugin autocmd runs before stimpack's ft loader, so the buffer would
-- otherwise be colorized before the plugin exists. `ft` stays here so stimpack
-- still owns installing/locking it.
return {
  "m00qek/baleia.nvim",
  ft = "ansi",
}
