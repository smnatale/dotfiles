local terminal = "com.superlogical.terminal"

-- the focused pane's directory, from what the shell last reported or else its foreground process
local function focused_cwd(ctx)
	local pwd = rex.block.call(terminal, "pwd", { block_id = ctx.block_id })
	if pwd and pwd.pwd then
		return (pwd.pwd:gsub("^file://[^/]*", ""))
	end
	local proc = rex.block.call(terminal, "process", { block_id = ctx.block_id })
	return proc and proc.foreground and proc.foreground.cwd
end

-- a palette action that opens a floating pane in the focused pane's directory, running command or a shell
local function float(name, title, keywords, command)
	rex.action({
		name = name,
		title = title,
		keywords = keywords,
		run = function(ctx)
			local _, err = rex.session.new_layer({
				-- x, y, w, h as fractions of the window
				bounds = { 0.05, 0.05, 0.9, 0.9 },
				layout = rex.layout.block({
					flavor = terminal .. ".shell",
					options = { command = command, cwd = focused_cwd(ctx) },
				}),
				focus = true,
			})
			if err then
				error(err)
			end
		end,
	})
end

float("scratch_float", "Scratch Terminal", "scratch terminal float")
float("lazygit_float", "Lazygit", "git lazygit float", { "lazygit" })
