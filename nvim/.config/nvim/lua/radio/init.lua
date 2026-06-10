local M = {}

-- Radio station specs. Each entry is { name = "...", src = "..." }.
M.stations = {
  {
    name = "Sonic 102.9 - Edmonton",
    src = "https://rogers-hls.leanstream.co/rogers/edm1029.stream/48k/playlist.m3u8",
  },
  {
    name = "Jack 103.1 - Victoria",
    src = "https://rogers-hls.leanstream.co/rogers/vic1031.stream/48k/playlist.m3u8",
  },
  {
    name = "KiSS 107.7 - Lethbridge",
    src = "https://rogers-hls.leanstream.co/rogers/let1077.stream/48k/playlist.m3u8",
  },
  {
    name = "106.7 ROCK - Lethbridge",
    src = "https://rogers-hls.leanstream.co/rogers/let1067.stream/48k/playlist.m3u8",
  },
  {
    name = "STAR 95.9 - Calgary",
    src = "https://rogers-hls.leanstream.co/rogers/cal959.stream/48k/playlist.m3u8",
  },
  {
    name = "Sportsnet 960 - Calgary",
    src = "https://rogers-hls.leanstream.co/rogers/cal960.stream/48k/playlist.m3u8",
  },
  {
    name = "Sportsnet 590 - Toronto",
    src = "https://rogers-hls.leanstream.co/rogers/tor590.stream/48k/playlist.m3u8",
  },
  {
    name = "The Rocket - Toronto",
    src = "https://rogers-hls.leanstream.co/rogers/natweb1.stream/48k/playlist.m3u8",
  },
  {
    name = "CBC Radio 1 - Calgary",
    source = "https://cbcradiolive.akamaized.net/hls/live/2041041/ES_R1MED/master.m3u8",
  },
  {
    name = "Groove Salad - SomaFM",
    source = "https://hls.somafm.com/hls/groovesalad/320k/program.m3u8",
  }
}

-- Handle of the currently running mpv job, or nil when nothing is playing.
M.job = nil
M.now_playing = nil

function M.stop()
  if M.job then
    vim.fn.jobstop(M.job)
    M.job = nil
    M.now_playing = nil
  end
end

local function play(station)
  M.stop()
  M.job = vim.fn.jobstart(
    { "mpv", "--no-video", "--no-terminal", "--quiet", station.src },
    {
      on_exit = function(job, _, _)
        -- Only clear state if this is still the active job (a newer play()
        -- call may have already replaced it).
        if M.job == job then
          M.job = nil
          M.now_playing = nil
        end
      end,
    }
  )

  if M.job <= 0 then
    M.job = nil
    vim.notify("radio: failed to start mpv (is it installed?)", vim.log.levels.ERROR)
    return
  end

  M.now_playing = station.name
  vim.notify("radio: playing " .. station.name)
end

-- Prompt for a station and start playing it.
function M.select()
  if #M.stations == 0 then
    vim.notify("radio: no stations configured", vim.log.levels.WARN)
    return
  end

  vim.ui.select(M.stations, {
    prompt = "Radio station",
    format_item = function(item) return item.name end,
  }, function(choice)
    if choice then play(choice) end
  end)
end

function M.setup(opts)
  opts = opts or {}
  if opts.stations then
    M.stations = opts.stations
  end

  vim.api.nvim_create_user_command("Radio", M.select, { desc = "Play a radio station" })
  vim.api.nvim_create_user_command("RadioStop", M.stop, { desc = "Stop radio playback" })

  -- Make sure mpv doesn't outlive the editor.
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function() M.stop() end,
  })
end

return M
