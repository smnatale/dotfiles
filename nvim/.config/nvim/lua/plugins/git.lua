vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/martindur/zdiff.nvim" },
})

require("gitsigns").setup({
	current_line_blame = true,
})

require("zdiff").setup()

vim.keymap.set("n", "<leader>gm", ":Gitsigns diffthis main<cr>", { silent = true, desc = "Diff against main" })

vim.keymap.set("n", "<leader>gf", ":15split|0Git<cr>", { silent = true, desc = "Git fugitive status" })
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<cr>", { silent = true, desc = "Git diff split" })
vim.keymap.set("n", "<leader>gl", ":Git log --oneline<cr>", { silent = true, desc = "Git log" })

vim.keymap.set("n", "<leader>zd", function()
	require("zdiff").open()
end, { desc = "Zdiff (uncommitted)" })
vim.keymap.set("n", "<leader>zD", function()
	require("zdiff").open("main")
end, { desc = "Zdiff (vs main)" })
