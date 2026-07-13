-- pre install
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "fff.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("fff.nvim")
			end
			require("fff.download").download_or_build_binary()
		end
	end,
})

-- plugins
vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" })

-- ensure binary is available
local fff_download = require("fff.download")
if not fff_download.binary_exists then
	fff_download.download_or_build_binary()
end

-- options
local fff = require("fff")

fff.setup({
	prompt = "❯ ",
	lazy_sync = true,
	keymaps = {
		close = "<Esc>",
		select = "<CR>",
		move_up = { "<Up>", "<C-k>" },
		move_down = { "<Down>", "<C-j>" },
		preview_scroll_up = "<C-u>",
		preview_scroll_down = "<C-d>",
		toggle_select = "<Tab>",
		send_to_quickfix = "<C-q>",
		focus_list = "<leader>l",
		focus_preview = "<leader>p",
		git = {
			status_text_color = true,
		},
	},
})

-- keymaps
vim.keymap.set("n", "<leader>sf", fff.find_files)
vim.keymap.set("n", "<leader>sg", fff.live_grep)
