-- Monitor Configuration
-- https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Default: auto-detect and use preferred resolution for any unspecified monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- ThinkPad T14s 
hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "1920x0", scale = 1 })

-- BENQ 27"
hl.monitor({ output = "desc:BNQ BenQ GL2780 ETN7L07855SL0", mode = "1920x1080@60", position = "3840x0", scale = 1 })

-- ThinkPad P43s
--hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "1920x0", scale = 1 })

-- External monitor examples
-- 27" 4K on the right
-- hl.monitor({ output = "DP-1", mode = "3840x2160@60", position = "1920x0", scale = 1.5 })
-- 27" 1440p on the right
-- hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@144", position = "1920x0", scale = 1 })
-- Mirror laptop display
-- hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0", scale = 1, mirror = "eDP-1" })

-- Desktop: dual LG ultrawides — match by description so these rules only fire
-- on the actual desktop monitors (not e.g. a BenQ on the laptop's HDMI port).
-- HDMI-A-1 landscape (left), DP-1 rotated portrait (right).
hl.monitor({ output = "desc:LG Electronics LG ULTRAWIDE 0x0001D52A", mode = "2560x1080@60", position = "0x0",    scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG ULTRAWIDE 0x0004F527", mode = "2560x1080@60", position = "2560x0", scale = 1, transform = 1 })
