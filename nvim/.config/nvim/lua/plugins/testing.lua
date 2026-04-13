vim.pack.add({
	{ src = "https://github.com/nvim-neotest/neotest" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/fredrikaverpil/neotest-golang" },
})

require("neotest").setup({
	adapters = {
		require("neotest-golang")(),
	},
})

vim.keymap.set("n", "<leader>mr", ":Neotest run<cr>", { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>ms", ":Neotest summary<cr>", { desc = "Test summary" })
vim.keymap.set("n", "<leader>mo", ":Neotest output<cr>", { desc = "Test output" })
vim.keymap.set("n", "<leader>mp", ":Neotest output-panel<cr>", { desc = "Test output panel" })
