local sbar = require("sketchybar")
local colors = require("colors")

local spaces = {}
local space_names = {}

local function add_space(id, label)
	local name = "space." .. id
	local item = sbar.add("item", name, {
		position = "left",
		drawing = true,
		icon = {
			string = label,
			color = colors.text_muted,
			font = "CaskaydiaCove Nerd Font:Bold:14.0",
			padding_left = 6,
			padding_right = 6,
		},
		label = { drawing = false },
		background = { drawing = false },
		padding_left = 3,
		padding_right = 3,
		click_script = "omniwmctl workspace focus-name " .. id,
	})

	spaces[#spaces + 1] = { id = id, item = item }
	space_names[#space_names + 1] = name
end

local function set_active_space_style(space)
	space.item:set({
		icon = { color = 0xff0c0c0c },
		background = {
			drawing = true,
			color = colors.accent,
			corner_radius = 8,
			height = 26,
		},
	})
end

local function set_inactive_space_style(space)
	space.item:set({
		icon = { color = colors.text_muted },
		background = { drawing = false },
	})
end

local function refresh_active_space()
	sbar.exec(
		"omniwmctl query active-workspace --format json | jq -r '.result.payload.workspace.id'",
		function(active_id)
			local active = (active_id or ""):gsub("%s+", "")
			for _, space in ipairs(spaces) do
				local is_active = space.id == active
				if is_active then
					set_active_space_style(space)
				else
					set_inactive_space_style(space)
				end
			end
		end
	)
end

sbar.exec(
	"omniwmctl query workspaces --format json | jq -r '.result.payload.workspaces[] | \"\\(.id)|\\(.displayName)\"'",
	function(workspaces)
		for row in string.gmatch(workspaces, "[^\r\n]+") do
			local id, display = row:match("([^|]+)|(.+)")
			if id ~= nil and id ~= "" then
				local cleaned = display:gsub("^%s+", "")
				add_space(id, cleaned)
			end
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

		refresh_active_space()
	end
)

local workspace_observer = sbar.add("item", "spaces.observer", {
	drawing = false,
	updates = true,
})
workspace_observer:subscribe("omniwm_workspace_change", refresh_active_space)
