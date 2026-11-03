local terminal = "com.superlogical.terminal"

-- the focused pane's foreground process, with its name, pid and cwd
local function foreground(ctx)
	local proc = rex.block.call(terminal, "process", { block_id = ctx.block_id })
	return proc and proc.foreground
end

-- the focused pane's directory, from what the shell last reported or else its foreground process
local function focused_cwd(ctx)
	local pwd = rex.block.call(terminal, "pwd", { block_id = ctx.block_id })
	if pwd and pwd.pwd then
		return (pwd.pwd:gsub("^file://[^/]*", ""))
	end
	local fg = foreground(ctx)
	return fg and fg.cwd
end

-- a terminal pane layout running command, or a shell if command is nil, in cwd
local function shell(command, cwd)
	return rex.layout.block({ flavor = terminal .. ".shell", options = { command = command, cwd = cwd } })
end

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
				layout = shell(spec.command, focused_cwd(ctx)),
				focus = true,
			})
			if err then
				error(err)
			end
		end,
	})
end

-- the scripts next to this file, and the float sizes they use
local scripts = os.getenv("HOME") .. "/.config/rex/"
local picker = { 0.25, 0.2, 0.5, 0.5 }
local prompt = { 0.3, 0.4, 0.4, 0.2 }

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

float({
	name = "open_project",
	title = "Open Project",
	keywords = "project folder session open",
	command = { scripts .. "open-project.sh" },
	bounds = picker,
})

float({
	name = "new_worktree",
	title = "New Worktree",
	keywords = "worktree branch wt",
	command = { scripts .. "new-worktree.sh" },
	bounds = prompt,
})

float({
	name = "open_worktree",
	title = "Open Worktree",
	keywords = "worktree branch session open wt",
	command = { scripts .. "open-worktree.sh" },
	bounds = picker,
})

float({
	name = "remove_worktree",
	title = "Remove Worktree",
	keywords = "worktree branch remove delete wt",
	command = { scripts .. "remove-worktree.sh" },
	bounds = picker,
})

-- splits a fork of the focused pane's claude session to the right, found by its pid in ~/.claude/sessions
rex.action({
	name = "fork_claude",
	title = "Fork Claude",
	keywords = "claude fork split session",
	run = function(ctx)
		local fg = foreground(ctx)
		if not fg or fg.name ~= "claude" then
			error("the focused pane isn't running claude")
		end
		local path = os.getenv("HOME") .. "/.claude/sessions/" .. fg.pid .. ".json"
		local f = io.open(path)
		if not f then
			error("no claude session file at " .. path)
		end
		local id = rex.json.decode(f:read("*a")).sessionId
		f:close()
		if not id then
			error("no sessionId in " .. path)
		end
		local _, err = rex.session.new_split({
			anchor_id = ctx.block_id,
			direction = "horizontal",
			side = "after",
			layout = shell({ "claude", "--resume", id, "--fork-session" }, fg.cwd),
			focus = true,
		})
		if err then
			error(err)
		end
	end,
})

rex.action({
	name = "open_in_finder",
	title = "Open in Finder",
	keywords = "finder reveal open directory",
	run = function(ctx)
		local dir = focused_cwd(ctx)
		if not dir then
			error("no directory for the focused pane")
		end
		rex.exec({ "open", dir })
	end,
})
