local terminal = "com.superlogical.terminal"

local home = os.getenv("HOME")
local project_roots = { personal = home .. "/Projects/personal", work = home .. "/Projects/work" }

local function session_with_label(label)
	local list, err = rex.call("session.list")
	if err then
		error(err)
	end
	for _, session in ipairs(list.sessions) do
		if session.label == label then
			return session.session_id
		end
	end
end

-- open a session named after the folder, or switch to it if it's already open
local function open_session(dir, label)
	local session_id = session_with_label(label)
	if not session_id then
		local created, err = rex.call("session.create", {
			label = label,
			initial_windows = {
				{ layout = rex.layout.block({ flavor = terminal .. ".shell", options = { cwd = dir } }) },
			},
		})
		if err then
			error(err)
		end
		session_id = created.session_id
		local _, attach_err = rex.call("session.attach", { session_id = session_id })
		if attach_err then
			error(attach_err)
		end
	end
	rex.client.queue("session.select", { session_id = session_id })
end

-- one palette action per project folder, picked up when the config loads
for key, root in pairs(project_roots) do
	local listed = rex.exec({ "find", root, "-mindepth", "1", "-maxdepth", "1", "-type", "d", "-not", "-name", ".*" })
	if listed and listed.ok then
		for dir in listed.stdout:gmatch("[^\n]+") do
			local name = dir:match("[^/]+$")
			local label = "~/Projects/" .. key .. "/" .. name
			rex.action({
				name = "open_" .. key .. "_" .. name:lower():gsub("[^%w]", "_"),
				title = label,
				category = "Directories",
				keywords = name,
				run = function()
					open_session(dir, label)
				end,
			})
		end
	end
end
