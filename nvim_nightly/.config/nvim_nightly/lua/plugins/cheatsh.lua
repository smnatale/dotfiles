local function url_encode(value)
	return value:gsub("([^%w%-_%.~])", function(char)
		return string.format("%%%02X", string.byte(char))
	end)
end

local function strip_ansi(value)
	return value:gsub("\27%[[0-9;?]*[ -/]*[@-~]", ""):gsub("\r", "")
end

local function show_cheat(query, result)
	vim.cmd("vnew")
	vim.cmd("wincmd L")
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_name(buf, "cheat://go/" .. query)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(strip_ansi(result), "\n", { plain = true }))
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "go"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = false
	vim.bo[buf].swapfile = false
	vim.cmd("normal! gg")
end

local function fetch_cheat(query)
	vim.system({
		"curl",
		"--fail-with-body",
		"--silent",
		"--show-error",
		"--location",
		"--connect-timeout",
		"5",
		"--max-time",
		"15",
		"https://cht.sh/go/" .. url_encode(query),
	}, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				vim.notify(result.stderr ~= "" and result.stderr or "cheat.sh returned no result", vim.log.levels.ERROR)
				return
			end
			show_cheat(query, result.stdout)
		end)
	end)
end

local function cheatsh()
	vim.ui.input({
		prompt = "Go query: ",
		default = vim.fn.expand("<cword>"),
	}, function(query)
		if query and query:match("%S") then
			fetch_cheat(query)
		end
	end)
end

vim.api.nvim_create_user_command("Cheat", cheatsh, { desc = "Search Go on cheat.sh" })
vim.keymap.set("n", "<leader>sc", cheatsh, { desc = "Search Go on cheat.sh" })
