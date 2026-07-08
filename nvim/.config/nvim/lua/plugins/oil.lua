-- plugins
vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/refractalize/oil-git-status.nvim",
})

-- options
local oil = require("oil")
local oil_git_status = require("oil-git-status")

oil.setup({
	skip_confirm_for_simple_edits = true,
	win_options = {
		signcolumn = "yes:2",
	},
	view_options = {
		show_hidden = true,
	},
	watch_for_changes = true,
})

oil_git_status.setup({
	show_ignored = false,
})

-- keymaps
vim.keymap.set("n", "<leader>e", ":Oil<cr>", { silent = true })
