require("oil").setup({
	win_options = {
		signcolumn = "yes:2",
	},
	view_options = {
		show_hidden = true,
	},
	watch_for_changes = true,
})
require("oil-git-status").setup({
	show_ignored = false,
})

vim.keymap.set("n", "<leader>e", ":Oil<cr>", { silent = true })
