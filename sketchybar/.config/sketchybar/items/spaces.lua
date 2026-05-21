local sbar = require("sketchybar")
local colors = require("colors")

local user = os.getenv("USER") or ""
local home = os.getenv("HOME") or ("/Users/" .. user)
local spaces_plist = home .. "/Library/Preferences/com.apple.spaces.plist"
local plugin_dir = (os.getenv("CONFIG_DIR") or (home .. "/.config/sketchybar")) .. "/plugins"
local space_names = {}

local key_codes = {
	18,
	19,
	20,
	21,
	23,
	22,
	26,
	28,
	25,
}

local function focus_script(space)
	local key_code = key_codes[space]
	if key_code == nil then
		return nil
	end

	return "osascript -e 'tell application \"System Events\" to key code " .. key_code .. " using control down'"
end

local function add_space(space, active_space)
	local name = "space." .. space
	local is_active = space == active_space
	sbar.add("space", name, {
		position = "left",
		space = space,
		drawing = true,
		icon = {
			string = tostring(space),
			color = is_active and 0xff0c0c0c or colors.text_muted,
			font = "CaskaydiaCove Nerd Font:Bold:14.0",
			padding_left = 6,
			padding_right = 6,
		},
		label = { drawing = false },
		background = {
			drawing = is_active,
			color = colors.accent,
			corner_radius = 8,
			height = 26,
		},
		padding_left = 3,
		padding_right = 3,
		script = plugin_dir .. "/space.sh",
		click_script = focus_script(space),
	})

	space_names[#space_names + 1] = name
end

local space_count_script = table.concat({
	'/usr/bin/plutil -convert json -o - "' .. spaces_plist .. '" 2>/dev/null',
	'| /usr/bin/jq -r \'.SpacesDisplayConfiguration["Management Data"].Monitors[]? | select(.Spaces != null) | . as $m | ($m["Current Space"].ManagedSpaceID // $m["Current Space"].id64) as $current | [$m.Spaces[] | select(.type == 0)] as $spaces | "\\($spaces | length)|\\(([$spaces[].ManagedSpaceID] | index($current) // -1) + 1)"\'',
}, " ")

sbar.exec(space_count_script, function(output)
	local count_text, active_text = (output or ""):match("(%d+)|(%d+)")
	local count = tonumber(count_text) or 0
	local active_space = tonumber(active_text) or 0
	if count < 1 then
		count = 1
	end

	for space = 1, count, 1 do
		add_space(space, active_space)
	end

	if #space_names > 0 then
		sbar.add("bracket", space_names, {
			background = {
				color = colors.inactive,
				corner_radius = 8,
				height = 26,
				padding_left = 8,
				padding_right = 8,
			},
		})
	end
end)
