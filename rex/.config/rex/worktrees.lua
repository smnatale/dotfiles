-- palette actions for opening projects and creating, opening and removing wt worktrees
local util = require("util")
local home, ask, run, exec, tilde = util.home, util.ask, util.run, util.exec, util.tilde

local project_roots = { home .. "/Projects/personal", home .. "/Projects/work" }

-- every worktree under ~/.worktrees/<repo>/<branch>, as tables of label (repo/branch), branch, path,
-- main (the repo's main checkout) and symbols (wt's status), sorted by label.
-- wt lists all of a repo's worktrees from any one of them, so it runs once per repo, and a repo it can't
-- list, such as one whose main checkout has moved, is skipped rather than failing them all
local function all_worktrees()
	local repos = {}
	local found = run({ "find", home .. "/.worktrees", "-mindepth", "2", "-maxdepth", "2", "-type", "d" })
	for dir in found:gmatch("[^\n]+") do
		repos[dir:match("([^/]+)/[^/]+$")] = dir
	end
	local worktrees = {}
	for repo, dir in pairs(repos) do
		local r = exec({ "wt", "list", "--format", "json" }, dir)
		if r and r.ok then
			local items = rex.json.decode(r.stdout).items
			local main
			for _, item in ipairs(items) do
				if item.worktree.main then
					main = item.worktree.path
				end
			end
			for _, item in ipairs(items) do
				if main and not item.worktree.main and item.branch then
					table.insert(worktrees, {
						label = repo .. "/" .. item.branch,
						branch = item.branch,
						path = item.worktree.path,
						main = main,
						symbols = item.display and item.display.symbols,
					})
				end
			end
		end
	end
	table.sort(worktrees, function(a, b)
		return a.label < b.label
	end)
	return worktrees
end

-- asks to pick one of worktrees, returning the chosen one or nil
local function pick_worktree(title, worktrees)
	local items, by_path = {}, {}
	for _, wt in ipairs(worktrees) do
		by_path[wt.path] = wt
		table.insert(
			items,
			{ id = wt.path, title = wt.label, subtitle = tilde(wt.path), detail = wt.symbols, icon = "branch" }
		)
	end
	local path = ask(rex.ui.pick, { title = title, placeholder = "Filter worktrees", items = items })
	return path and by_path[path]
end

-- picks a project folder and switches to a session labelled with its ~ path, opening one if needed
rex.action({
	name = "open_project",
	title = "Open Project",
	keywords = "project folder session open",
	run = function()
		local items = {}
		for _, root in ipairs(project_roots) do
			-- a missing root just has no projects
			local r = exec({ "find", root, "-mindepth", "1", "-maxdepth", "1", "-type", "d", "-not", "-name", ".*" })
			for dir in (r and r.ok and r.stdout or ""):gmatch("[^\n]+") do
				table.insert(items, { id = dir, title = dir:match("[^/]+$"), subtitle = tilde(dir), icon = "folder" })
			end
		end
		table.sort(items, function(a, b)
			return a.id < b.id
		end)
		local dir = ask(rex.ui.pick, { title = "Open project", placeholder = "Filter projects", items = items })
		if dir then
			util.open_session(tilde(dir), dir)
		end
	end,
})

-- the repo's local and remote branches as pick items, most recently committed first, with id the branch name.
-- a remote branch shows once under its plain name, and only when there's no local branch of that name
local function branch_items(main)
	local refs = run({
		"git",
		"for-each-ref",
		"--sort=-committerdate",
		"--count=500",
		"--format=%(refname)%09%(committerdate:relative)%09%(contents:subject)",
		"refs/heads",
		"refs/remotes",
	}, main)
	-- note the local branches first, so a newer remote copy listed before its local branch is skipped
	local locals = {}
	for name in refs:gmatch("refs/heads/([^\t\n]+)") do
		locals[name] = true
	end
	local items, seen = {}, {}
	for ref, date, subject in refs:gmatch("([^\t\n]+)\t([^\t\n]*)\t([^\n]*)") do
		local name, is_remote = ref:match("^refs/heads/(.+)$"), false
		if not name then
			name, is_remote = ref:match("^refs/remotes/[^/]+/(.+)$"), true
		end
		if name and name ~= "HEAD" and not seen[name] and not (is_remote and locals[name]) then
			seen[name] = true
			table.insert(items, {
				id = name,
				subtitle = subject,
				detail = is_remote and "remote · " .. date or date,
				icon = is_remote and "globe" or "branch",
			})
		end
	end
	return items, seen
end

-- picks an existing branch, or takes a typed name for a new one, and opens a repo/branch session whose shell
-- starts once wt has made the worktree. wt switches to a branch's existing worktree, and makes a local tracking
-- branch for a remote one. running wt in the pane shows its pre-start copy and keeps it off the action's time limit
rex.action({
	name = "new_worktree",
	title = "New Worktree",
	keywords = "worktree branch checkout switch wt",
	run = function(ctx)
		-- the shared .git sits in the main checkout, wherever in the repo the focused pane is
		local git_dir = run({ "git", "rev-parse", "--path-format=absolute", "--git-common-dir" }, util.focused_cwd(ctx))
		local main = git_dir:gsub("%s+$", ""):gsub("/%.git$", "")
		local items, exists = branch_items(main)
		local answer = ask(rex.ui.pick, {
			title = "Worktree for branch",
			placeholder = "Pick a branch, or type a new one",
			items = items,
			allow_other = true,
		})
		-- a typed name comes back as { text = ... }
		local branch = type(answer) == "table" and answer.text:match("^%s*(.-)%s*$") or answer
		if not branch or branch == "" then
			return
		end
		local command = { "wt", "switch", branch, "--no-cd", "-x", os.getenv("SHELL") or "/bin/zsh" }
		if not exists[branch] then
			table.insert(command, 3, "--create")
		end
		util.open_session(main:match("[^/]+$") .. "/" .. branch, main, command)
	end,
})

-- picks any worktree and switches to its repo/branch session, opening one if needed
rex.action({
	name = "open_worktree",
	title = "Open Worktree",
	keywords = "worktree branch session open wt",
	run = function()
		local worktrees = all_worktrees()
		if #worktrees == 0 then
			error("no worktrees in ~/.worktrees", 0)
		end
		local wt = pick_worktree("Open worktree", worktrees)
		if wt then
			util.open_session(wt.label, wt.path)
		end
	end,
})

-- picks any worktree and removes it with wt, whose post-remove hook closes its session.
-- wt keeps unmerged branches and refuses worktrees with uncommitted changes, so offer to force it then
rex.action({
	name = "remove_worktree",
	title = "Remove Worktree",
	keywords = "worktree branch remove delete wt",
	run = function()
		local worktrees = all_worktrees()
		if #worktrees == 0 then
			error("no worktrees to remove in ~/.worktrees", 0)
		end
		local wt = pick_worktree("Remove worktree", worktrees)
		if not wt then
			return
		end
		-- run wt from the main checkout, so removing the worktree this pane is in works too
		local r, err = exec({ "wt", "-C", wt.main, "remove", "--foreground", wt.branch })
		if r == nil then
			error(err, 0)
		end
		if r.ok then
			return
		end
		local why = (r.stderr ~= "" and r.stderr or r.stdout):match("[^\n]*%S[^\n]*")
		local force = ask(rex.ui.pick, {
			title = "Remove " .. wt.label .. " anyway?",
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
			run({ "wt", "-C", wt.main, "remove", "--foreground", "--force", wt.branch })
		end
	end,
})
