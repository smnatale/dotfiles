require("neotest").setup({
	adapters = {
		require("neotest-golang")(),
	},
})

vim.keymap.set("n", "<leader>tr", ":Neotest run<cr>", { silent = true, desc = "Run nearest test" })
vim.keymap.set("n", "<leader>ts", ":Neotest summary<cr>", { silent = true, desc = "Test summary" })
vim.keymap.set("n", "<leader>to", ":Neotest output<cr>", { silent = true, desc = "Test output" })
vim.keymap.set("n", "<leader>tp", ":Neotest output-panel<cr>", { silent = true, desc = "Test output panel" })
