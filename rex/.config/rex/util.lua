-- helpers shared by actions.lua and worktrees.lua
local M = {}

M.terminal = "com.superlogical.terminal"
M.home = os.getenv("HOME")

-- the focused pane's foreground process, with its name, pid and cwd
function M.foreground(ctx)
	local proc = rex.block.call(M.terminal, "process", { block_id = ctx.block_id })
	return proc and proc.foreground
end

-- the focused pane's directory, from what the shell last reported or else its foreground process
function M.focused_cwd(ctx)
	local pwd = rex.block.call(M.terminal, "pwd", { block_id = ctx.block_id })
	if pwd and pwd.pwd then
		return (pwd.pwd:gsub("^file://[^/]*", ""))
	end
	local fg = M.foreground(ctx)
	return fg and fg.cwd
end

-- a terminal pane layout running command, or a shell if command is nil, in cwd
function M.shell(command, cwd)
	return rex.layout.block({ flavor = M.terminal .. ".shell", options = { command = command, cwd = cwd } })
end

-- the server starts with launchd's bare PATH, so add homebrew for wt and rex's own bin for wt's post-remove hook
local exec_path = table.concat({
	"/opt/homebrew/bin",
	M.home
		.. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS",
	os.getenv("PATH") or "/usr/bin:/bin:/usr/sbin:/sbin",
}, ":")

-- rex.exec with that PATH, run in cwd
function M.exec(argv, cwd)
	return rex.exec(argv, { cwd = cwd, env = { PATH = exec_path } })
end

-- runs argv in cwd and returns its stdout, raising what it printed if it fails
function M.run(argv, cwd)
	local r, err = M.exec(argv, cwd)
	if r == nil then
		error(err, 0)
	end
	if not r.ok then
		local out = r.stderr ~= "" and r.stderr or r.stdout
		error((out:gsub("%s+$", "")), 0)
	end
	return r.stdout
end

-- asks with rex.ui.input or rex.ui.pick, returning nil when cancelled and raising on any other failure
function M.ask(prompt, spec)
	local answer, why, detail = prompt(spec)
	if answer == nil and why ~= "cancelled" then
		error("couldn't ask: " .. why .. (detail and (", " .. detail) or ""), 0)
	end
	return answer
end

-- path with the home directory shortened to ~
function M.tilde(path)
	if path:sub(1, #M.home) == M.home then
		return "~" .. path:sub(#M.home + 1)
	end
	return path
end

-- switches the app to the session labelled label, first creating it with a shell running command in dir
-- if it isn't open. needs a client, so it only switches when run from the app
function M.open_session(label, dir, command)
	local list, err = rex.call("session.list")
	if err then
		error(err, 0)
	end
	for _, s in ipairs(list.sessions) do
		if s.label == label then
			rex.client.queue("session.select", { session_id = s.session_id })
			return
		end
	end
	local created, cerr = rex.call("session.create", {
		label = label,
		initial_windows = { { layout = M.shell(command, dir) } },
	})
	if cerr then
		error(cerr, 0)
	end
	rex.client.queue("session.select", { session_id = created.session_id })
end

return M
