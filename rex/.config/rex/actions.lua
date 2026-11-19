-- small standalone palette actions: floats, forking claude and finder
local util = require("util")

-- a palette action that opens a floating pane in the focused pane's directory, running command or a shell
-- bounds is x, y, w, h as fractions of the window, nearly full-window by default
local function float(spec)
	rex.action({
		name = spec.name,
		title = spec.title,
		keywords = spec.keywords,
		run = function(ctx)
			local _, err = rex.session.new_layer({
				bounds = spec.bounds or { 0.05, 0.05, 0.9, 0.9 },
				layout = util.shell(spec.command, util.focused_cwd(ctx)),
				focus = true,
			})
			if err then
				error(err, 0)
			end
		end,
	})
end

float({
	name = "scratch_float",
	title = "Scratch Terminal",
	keywords = "scratch terminal float",
})

float({
	name = "lazygit_float",
	title = "Lazygit",
	keywords = "git lazygit float",
	command = { "lazygit" },
})

-- splits a fork of the focused pane's claude session to the right, found by its pid in ~/.claude/sessions
rex.action({
	name = "fork_claude",
	title = "Fork Claude",
	keywords = "claude fork split session",
	run = function(ctx)
		local fg = util.foreground(ctx)
		if not fg or fg.name ~= "claude" then
			error("the focused pane isn't running claude", 0)
		end
		local path = util.home .. "/.claude/sessions/" .. fg.pid .. ".json"
		local f = io.open(path)
		if not f then
			error("no claude session file at " .. path, 0)
		end
		local id = rex.json.decode(f:read("*a")).sessionId
		f:close()
		if not id then
			error("no sessionId in " .. path, 0)
		end
		local _, err = rex.session.new_split({
			anchor_id = ctx.block_id,
			direction = "horizontal",
			side = "after",
			layout = util.shell({ "claude", "--resume", id, "--fork-session" }, fg.cwd),
			focus = true,
		})
		if err then
			error(err, 0)
		end
	end,
})

rex.action({
	name = "open_in_finder",
	title = "Open in Finder",
	keywords = "finder reveal open directory",
	run = function(ctx)
		local dir = util.focused_cwd(ctx)
		if not dir then
			error("no directory for the focused pane", 0)
		end
		rex.exec({ "open", dir })
	end,
})
