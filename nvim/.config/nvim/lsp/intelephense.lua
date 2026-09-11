---@brief
---
--- https://intelephense.com/
---
--- `intelephense` can be installed via `npm`:
--- ```sh
--- npm install -g intelephense
--- ```
---
--- ```lua
--- -- See https://github.com/bmewburn/intelephense-docs/blob/master/installation.md#initialisation-options
--- init_options = {
---   storagePath = …, -- Optional absolute path to storage dir. Defaults to os.tmpdir().
---   globalStoragePath = …, -- Optional absolute path to a global storage dir. Defaults to os.homedir().
---   licenceKey = …, -- Optional licence key or absolute path to a text file containing the licence key.
---   clearCache = …, -- Optional flag to clear server state. State can also be cleared by deleting {storagePath}/intelephense
--- }
--- -- See https://github.com/bmewburn/intelephense-docs
--- settings = {
---   intelephense = {
---     files = {
---       maxSize = 1000000;
---     };
---   };
--- }
--- ```

return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_markers = { '.git', 'composer.json' },
  init_options = {
    licenceKey = os.getenv('HOME') .. '/intelephense/license.txt',
  },
  settings = {
    intelephense = {
      environment = {
        -- Every packages/*/composer.json claims ">=8.2", this machine runs
        -- 8.5. Gates *syntax* features only -- property hooks, asymmetric
        -- visibility, typed class constants all report "PHP 8.4+ syntax found.
        -- Targeting PHP 8.2." It does NOT filter the stdlib stubs, so an 8.4
        -- function like array_find() still resolves clean; phpstan.neon.dist's
        -- phpVersion.min is what catches those.
        phpVersion = '8.2.0',
      },
      format = {
        -- php-cs-fixer owns formatting (see lua/config/conform.lua); the
        -- project ruleset is not something intelephense can read.
        enable = false,
      },
      files = {
        -- Intelephense's stock list, plus the PHPUnit result cache. vendor/
        -- stays indexed -- symfony/console and the psr/* interfaces are worth
        -- navigating into; only the trees that cost index time and are never
        -- jumped to are dropped.
        exclude = {
          '**/.git/**',
          '**/.svn/**',
          '**/.hg/**',
          '**/CVS/**',
          '**/.DS_Store/**',
          '**/node_modules/**',
          '**/bower_components/**',
          '**/vendor/**/{Tests,tests}/**',
          '**/vendor/**/vendor/**',
          '**/.history/**',
          '**/.phpunit.cache/**',
        },
      },
    },
  },
}
