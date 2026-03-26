return {
  connections = {
    sshfs_options = {
      reconnect = true,         -- Auto-reconnect on connection loss
      ConnectTimeout = 5,       -- Connection timeout in seconds
      compression = "yes",      -- Enable compression
      ServerAliveInterval = 15, -- Keep-alive interval (15s × 3 = 45s timeout)
      ServerAliveCountMax = 3,  -- Keep-alive message count
      dir_cache = "yes",        -- Enable directory caching
      dcache_timeout = 300,     -- Cache timeout in seconds
      dcache_max_size = 10000,  -- Max cache size
      -- allow_other = true,        -- Allow other users to access mount
      -- uid = "1000,gid=1000",     -- Set file ownership (use string for complex values)
      follow_symlinks = true, -- Follow symbolic links
    }
  },
  mounts = {
    base_dir = vim.fn.expand("$HOME") .. "/.mount",
    auto_unmount = true,
    auto_change_to_dir = true,
  },
  ui = {
    local_picker = {
      preferred_picker = "mini",
      fallback_to_netrw = true,
      netrw_command = "Explore",
    },
    remote_picker = {
      preferred_picker = "mini",
    },
  },
  host_paths = {
    ['cl-alpha'] = '/var/www/alpha.chainlogic.net/web/will/cms',
    ['americabitcoin'] = '/mnt/enc/chainlogic-live/',
    ['ic-atm'] = {
      '/var/www/dev.instacoinatm.com',
      '/var/www/beta.instacoinatm.com',
      '/var/www/instacoinatm.com',
    },
    ['lamassu-polywell'] = '/opt/apps/machine/lamassu-machine',
    ['chainlogic'] = '/mnt/enc/chainlogic-dev',
    ['elitedesk'] = {
      '/home/whleucka/.dotfiles',
      '/home/whleucka/Projects/music',
      '/home/whleucka/Projects/echo',
    },
    ['hilt-app'] = '/var/www/app.hiltventures.com/hiltapp/dev',
    ['williamhleucka.com'] = {
      '/var/www/html/williamhleucka.com',
      '/var/www/html/git.williamhleucka.com',
      '/var/www/html/guitar.williamhleucka.com',
      '/var/www/html/mantis.williamhleucka.com',
      '/var/www/html/social.williamhleucka.com',
    }
  },
}
