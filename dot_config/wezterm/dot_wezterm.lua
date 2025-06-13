-- Test comment
-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux

-- This will hold the configuration
local config = wezterm.config_builder()


-- Config
config.initial_cols = 120
config.initial_rows = 28

-- Shell
config.default_prog = { 'nu' }

-- Font
config.font = wezterm.font("MesloLGLDZ Nerd Font Mono")
config.font_size = 10

-- Colors
config.color_scheme = 'GruvboxDark'
config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = '#d79921',
      fg_color = '#282828',
    }
  }
}

-- Window Appearance
config.window_decorations = "RESIZE"
-- config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- Use CTRL SHIFT L to open the wezterm console
-- wezterm.gui.enumerate_gpus() to show the available gpus
config.max_fps = 240
config.front_end = "WebGpu"
-- config.webgpu_preferred_adapter = {
--   backend = "Dx12",
--   device = 39880,
--   device_type = "IntegratedGpu",
--   name = "Intel(R) UHD Graphics 630",
--   vendor = 32902,
-- }
config.webgpu_preferred_adapter = {
  backend = "Vulkan",
  device = 39880,
  device_type = "IntegratedGpu",
  driver = "Intel Corporation",
  driver_info = "Intel driver",
  name = "Intel(R) UHD Graphics 630",
  vendor = 32902,
}

-- mux
config.leader = {
  key = "q",
  mods = "ALT",
  timeout_milliseconds = 2000
}
config.keys = {
  -- Tabs
  { mods = "ALT",       key = "t", action = wezterm.action.SpawnTab "CurrentPaneDomain" }, -- "c" in tmux
  { mods = "ALT",       key = "p", action = wezterm.action.ActivateTabRelative(-1) },
  { mods = "ALT",       key = "n", action = wezterm.action.ActivateTabRelative(1) },
  { mods = "ALT|SHIFT", key = "p", action = wezterm.action.MoveTabRelative(-1) },
  { mods = "ALT|SHIFT", key = "n", action = wezterm.action.MoveTabRelative(1) },
  -- Panes
  { mods = "ALT",       key = "x", action = wezterm.action.CloseCurrentPane { confirm = true } },
  { mods = "ALT",       key = "h", action = wezterm.action.ActivatePaneDirection "Left" },
  { mods = "ALT",       key = "j", action = wezterm.action.ActivatePaneDirection "Down" },
  { mods = "ALT",       key = "k", action = wezterm.action.ActivatePaneDirection "Up" },
  { mods = "ALT",       key = "l", action = wezterm.action.ActivatePaneDirection "Right" },
  { mods = "ALT|SHIFT", key = "h", action = wezterm.action.AdjustPaneSize { "Left", 5 } },
  { mods = "ALT|SHIFT", key = "j", action = wezterm.action.AdjustPaneSize { "Down", 5 } },
  { mods = "ALT|SHIFT", key = "k", action = wezterm.action.AdjustPaneSize { "Up", 5 } },
  { mods = "ALT|SHIFT", key = "l", action = wezterm.action.AdjustPaneSize { "Right", 5 } },
  { mods = "ALT",       key = "v", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { mods = "ALT",       key = "s", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
  { mods = "ALT",       key = "1", action = wezterm.action.ActivateTab(0) },
  { mods = "ALT",       key = "2", action = wezterm.action.ActivateTab(1) },
  { mods = "ALT",       key = "3", action = wezterm.action.ActivateTab(2) },
  { mods = "ALT",       key = "4", action = wezterm.action.ActivateTab(3) },
  { mods = "ALT",       key = "5", action = wezterm.action.ActivateTab(4) },
  { mods = "ALT",       key = "6", action = wezterm.action.ActivateTab(5) },
  { mods = "ALT",       key = "7", action = wezterm.action.ActivateTab(6) },
  { mods = "ALT",       key = "8", action = wezterm.action.ActivateTab(7) },
  { mods = "ALT",       key = "9", action = wezterm.action.ActivateTab(8) },
}


return config
