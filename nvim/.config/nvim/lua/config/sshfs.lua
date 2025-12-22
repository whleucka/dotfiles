return {
  connections = {
    sshfs_args = {
      "-o dir_cache=yes",          -- Enable directory entry caching
      "-o dcache_max_size=100000", -- Max number of cached entries
      "-o dcache_timeout=600",     -- Seconds entries are cached
      "-o dcache_stat_timeout=600",
      "-o dcache_link_timeout=600",
      "-o dcache_dir_timeout=600",
      --"-o large_read",             -- Reads more data per network roundtrip
      --"-o no_readahead",           -- don’t speculatively read more than requested
      --"-o sync_readdir",           -- For speed, probably leave off.
      "-o max_conns=3",            -- Lets SSHFS use multiple SSH sessions for simultaneous reads
      "-o reconnect",              -- Automatically reconnect if the connection drops
      "-o ConnectTimeout=5",       -- Time (in seconds) to wait before failing a connection attempt
      "-o compression=yes",        -- Enable compression to reduce bandwidth usage
      "-o ServerAliveInterval=15", -- Send a keepalive packet every 15 seconds to prevent timeouts
      "-o ServerAliveCountMax=3",  -- Number of missed keepalive packets before disconnecting
      "-o TCPKeepAlive=yes",       -- helps with NATs / routers being dumb
      --"-o IdentityFile=~/.ssh/id_rsa"
    },
  },
  mounts = {
    base_dir = vim.fn.expand("$HOME") .. "/.mount",
    auto_unmount = true,
    auto_change_to_dir = true,
  },
  host_paths = {
    ['cl-alpha'] = '/var/www/alpha.chainlogic.net/web/will/cms',
    ['ic-atm'] = {
      '/var/www/dev.instacoinatm.com',
      '/var/www/beta.instacoinatm.com',
      '/var/www/instacoinatm.com',
    },
    ['chainlogic'] = '/mnt/enc/chainlogic-dev',
    ['elitedesk'] = {
      '/home/whleucka/Projects/music',
      '/home/whleucka/Projects/echo',
    },
    ['williamhleucka.com'] = {
      '/var/www/',
    }
  },
}
