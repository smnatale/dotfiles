-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "tokyonight"
config.font = wezterm.font 'CaskaydiaCove Nerd Font'

config.leader = { key = 'Space', mods = 'SHIFT', timeout_milliseconds = 1000 }

config.keys = {
  {
    mods   = "LEADER",
    key    = "v",
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
    mods   = "LEADER",
    key    = "h",
    action = wezterm.action.SplitPane {
      direction = 'Down',
      size = { Percent = 20 },
    },
  },
  {
    mods = "LEADER",
    key = "c",
    action = wezterm.action.SpawnTab "CurrentPaneDomain",
  },
  {
    mods = "LEADER",
    key = "q",
    action = wezterm.action.CloseCurrentPane { confirm = true }
  },
  {
    mods = "LEADER",
    key = "LeftArrow",
    action = wezterm.action.ActivatePaneDirection "Left"
  },
  {
    mods = "LEADER",
    key = "RightArrow",
    action = wezterm.action.ActivatePaneDirection "Right"
  },
  {
    mods = "LEADER",
    key = "DownArrow",
    action = wezterm.action.ActivatePaneDirection "Down"
  },
  {
    mods = "LEADER",
    key = "UpArrow",
    action = wezterm.action.ActivatePaneDirection "Up"
  },
  {
    mods = 'LEADER',
    key = 'z',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    mods = 'LEADER',
    key = 'Space',
    action = wezterm.action.PaneSelect {
      mode = "SwapWithActive"
    },
  },
}

for i = 0, 5 do
  -- leader + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = wezterm.action.ActivateTab(i),
  })
end

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.inactive_pane_hsb = {
  saturation = 1,
  brightness = 1,
}

-- config.window_decorations = "RESIZE"

return config
