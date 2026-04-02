vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
})

require("gitsigns").setup({
	current_line_blame = true,
})

vim.keymap.set("n", "<leader>gm", ":Gitsigns diffthis main<cr>")

vim.keymap.set("n", "<leader>gf", ":15split|0Git<cr>")
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<cr>")
vim.keymap.set("n", "<leader>gl", ":Git log --oneline<cr>")
