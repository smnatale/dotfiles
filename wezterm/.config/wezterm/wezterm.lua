-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local custom = wezterm.color.get_builtin_schemes()["Tokyo Night"]
custom.background = "#090B10"
custom.tab_bar.background = "#06070A"
custom.tab_bar.inactive_tab.bg_color = "#06070A"
custom.tab_bar.new_tab.bg_color = "#06070A"

config.color_schemes = {
	["Custom Tokyo Night"] = custom,
}

config.color_scheme = "Custom Tokyo Night"

-- brew install --cask font-caskaydia-cove-nerd-font
config.font = wezterm.font("CaskaydiaCove Nerd Font", { weight = "Regular" })
config.font_size = 14

config.leader = { key = "s", mods = "CTRL" }

config.keys = {
	{
		mods = "LEADER",
		key = "v",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 20 },
		}),
	},
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "q",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "z",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		mods = "LEADER",
		key = "s",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
}

for i = 1, 5 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		-- minus 1 as tab starts at 0
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = false

config.window_padding = {
	left = 0,
	right = 0,
	top = 4,
	bottom = 0,
}

config.inactive_pane_hsb = {
	saturation = 1,
	brightness = 1,
}

-- config.window_decorations = "RESIZE"

return config
