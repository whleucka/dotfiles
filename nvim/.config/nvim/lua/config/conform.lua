local util = require("conform.util")

return {
  formatters_by_ft = {
    php = { "php_cs_fixer" },
  },

  formatters = {
    php_cs_fixer = {
      -- friendsofphp/php-cs-fixer is a require-dev pin, not a global install,
      -- so resolve it per-project. That also keeps the editor on whatever
      -- version composer.lock pins, which is the version CI checks against.
      command = util.find_executable({ "vendor/bin/php-cs-fixer" }, "php-cs-fixer"),
      args = { "fix", "--no-interaction", "--quiet", "$FILENAME" },
      stdin = false,

      -- php-cs-fixer discovers .php-cs-fixer.dist.php from the working
      -- directory, never from the path it is handed. Without the right cwd it
      -- would silently apply stock PSR-12 and undo `new AuthConfig` and the
      -- one-line empty bodies -- exactly the drift that config exists to stop.
      cwd = util.root_file({ ".php-cs-fixer.dist.php", ".php-cs-fixer.php" }),
      require_cwd = true,
    },
  },

  -- Filetypes with no entry above (lua, rust, python, ...) keep formatting
  -- through their language server as before.
  default_format_opts = {
    lsp_format = "fallback",
  },
}
