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

local home = os.getenv("HOME")

-- the server starts with launchd's bare PATH, so add homebrew for wt and rex's own bin for wt's post-remove hook
local exec_path = table.concat({
	"/opt/homebrew/bin",
	home
		.. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS",
	os.getenv("PATH") or "/usr/bin:/bin:/usr/sbin:/sbin",
}, ":")

-- rex.exec with that PATH, run in cwd
local function exec(argv, cwd)
	return rex.exec(argv, { cwd = cwd, env = { PATH = exec_path } })
end

-- runs argv in cwd and returns its stdout, raising what it printed if it fails
local function run(argv, cwd)
	local r, err = exec(argv, cwd)
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
local function ask(prompt, spec)
	local answer, why, detail = prompt(spec)
	if answer == nil and why ~= "cancelled" then
		error("couldn't ask: " .. why .. (detail and (", " .. detail) or ""), 0)
	end
	return answer
end

-- path with the home directory shortened to ~
local function tilde(path)
	if path:sub(1, #home) == home then
		return "~" .. path:sub(#home + 1)
	end
	return path
end

-- switches the app to the session labelled label, first creating it with a shell running command in dir
-- if it isn't open. needs a client, so it only switches when run from the app
local function open_session(label, dir, command)
	local list, err = rex.call("session.list")
	if err then
		error(err, 0)
	end
	local id
	for _, s in ipairs(list.sessions) do
		if s.label == label then
			id = s.session_id
			break
		end
	end
	if not id then
		local created, cerr = rex.call("session.create", {
			label = label,
			initial_windows = { { layout = shell(command, dir) } },
		})
		if cerr then
			error(cerr, 0)
		end
		id = created.session_id
	end
	rex.client.queue("session.select", { session_id = id })
end

-- the current repo's worktrees from wt, as the main checkout's path and the other worktrees' list items
local function worktrees(cwd)
	local list = rex.json.decode(run({ "wt", "list", "--format", "json" }, cwd))
	local main, others = nil, {}
	for _, item in ipairs(list.items) do
		if item.worktree.main then
			main = item.worktree.path
		elseif item.branch then
			table.insert(others, item)
		end
	end
	return main, others
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

-- picks a project folder and switches to a session labelled with its ~ path, opening one if needed
rex.action({
	name = "open_project",
	title = "Open Project",
	keywords = "project folder session open",
	run = function()
		-- find still lists the folders it can read when one root is missing, so its exit status is ignored
		local r, err = exec({
			"find",
			home .. "/Projects/personal",
			home .. "/Projects/work",
			"-mindepth",
			"1",
			"-maxdepth",
			"1",
			"-type",
			"d",
			"-not",
			"-name",
			".*",
		})
		if r == nil then
			error(err, 0)
		end
		local items = {}
		for dir in r.stdout:gmatch("[^\n]+") do
			table.insert(items, { id = dir, title = dir:match("[^/]+$"), subtitle = tilde(dir), icon = "folder" })
		end
		table.sort(items, function(a, b)
			return a.id < b.id
		end)
		local dir = ask(rex.ui.pick, { title = "Open project", placeholder = "Filter projects", items = items })
		if dir then
			open_session(tilde(dir), dir)
		end
	end,
})

-- asks for a branch and opens a repo/branch session whose shell starts once wt has created its worktree,
-- so wt's pre-start copy shows in the pane and doesn't count toward the action's time limit
rex.action({
	name = "new_worktree",
	title = "New Worktree",
	keywords = "worktree branch wt",
	run = function(ctx)
		local main = worktrees(focused_cwd(ctx))
		if not main then
			error("wt found no main checkout for this repo", 0)
		end
		local branch =
			ask(rex.ui.input, { title = "New worktree", placeholder = "Branch name", confirm = "Create worktree" })
		branch = branch and branch:match("^%s*(.-)%s*$")
		if not branch or branch == "" then
			return
		end
		local command = { "wt", "switch", "--create", branch, "--no-cd", "-x", os.getenv("SHELL") or "/bin/zsh" }
		open_session(main:match("[^/]+$") .. "/" .. branch, main, command)
	end,
})

-- picks any worktree under ~/.worktrees/<repo>/<branch> and switches to its repo/branch session, opening one if needed
rex.action({
	name = "open_worktree",
	title = "Open Worktree",
	keywords = "worktree branch session open wt",
	run = function()
		local items, labels = {}, {}
		local found = run({ "find", home .. "/.worktrees", "-mindepth", "2", "-maxdepth", "2", "-type", "d" })
		for dir in found:gmatch("[^\n]+") do
			-- the folder name is the sanitized branch, so read the real one from git
			local r = exec({ "git", "-C", dir, "branch", "--show-current" })
			local branch = r and r.ok and r.stdout:gsub("%s+$", "")
			if branch and branch ~= "" then
				labels[dir] = dir:match("([^/]+)/[^/]+$") .. "/" .. branch
				table.insert(items, { id = dir, title = labels[dir], subtitle = tilde(dir), icon = "branch" })
			end
		end
		if #items == 0 then
			error("no worktrees in ~/.worktrees", 0)
		end
		table.sort(items, function(a, b)
			return a.title < b.title
		end)
		local dir = ask(rex.ui.pick, { title = "Open worktree", placeholder = "Filter worktrees", items = items })
		if dir then
			open_session(labels[dir], dir)
		end
	end,
})

-- picks a worktree from any repo with one under ~/.worktrees and removes it with wt, whose post-remove hook
-- closes its session. wt keeps unmerged branches and refuses worktrees with uncommitted changes,
-- so offer to force it then
rex.action({
	name = "remove_worktree",
	title = "Remove Worktree",
	keywords = "worktree branch remove delete wt",
	run = function()
		-- one worktree folder per repo is enough for wt to list all of that repo's worktrees
		local repos = {}
		local found = run({ "find", home .. "/.worktrees", "-mindepth", "2", "-maxdepth", "2", "-type", "d" })
		for dir in found:gmatch("[^\n]+") do
			repos[dir:match("([^/]+)/[^/]+$")] = dir
		end
		local items, targets = {}, {}
		for repo, dir in pairs(repos) do
			-- skip a repo wt can't list, such as one whose main checkout has moved, rather than failing them all
			local ok, main, others = pcall(worktrees, dir)
			if ok and main then
				for _, item in ipairs(others) do
					local id = item.worktree.path
					targets[id] = { main = main, branch = item.branch }
					table.insert(items, {
						id = id,
						title = repo .. "/" .. item.branch,
						subtitle = tilde(id),
						detail = item.display and item.display.symbols,
						icon = "branch",
					})
				end
			end
		end
		if #items == 0 then
			error("no worktrees to remove in ~/.worktrees", 0)
		end
		table.sort(items, function(a, b)
			return a.title < b.title
		end)
		local picked = ask(rex.ui.pick, { title = "Remove worktree", placeholder = "Filter worktrees", items = items })
		if not picked then
			return
		end
		local main, branch = targets[picked].main, targets[picked].branch
		-- run wt from the main checkout, so removing the worktree this pane is in works too
		local r, err = exec({ "wt", "-C", main, "remove", "--foreground", branch })
		if r == nil then
			error(err, 0)
		end
		if r.ok then
			return
		end
		local why = (r.stderr ~= "" and r.stderr or r.stdout):match("[^\n]*%S[^\n]*")
		local force = ask(rex.ui.pick, {
			title = "Remove " .. branch .. " anyway?",
			items = {
				{
					id = "force",
					title = "Remove anyway, discarding uncommitted changes",
					subtitle = why,
					icon = "gear",
				},
				{ id = "keep", title = "Keep it" },
			},
		})
		if force == "force" then
			run({ "wt", "-C", main, "remove", "--foreground", "--force", branch })
		end
	end,
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
