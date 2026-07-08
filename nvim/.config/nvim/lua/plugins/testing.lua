-- plugins
vim.pack.add({
	"https://github.com/nvim-neotest/neotest",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/antoinemadec/FixCursorHold.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/fredrikaverpil/neotest-golang",
})

-- options
require("neotest").setup({
	adapters = {
		require("neotest-golang")(),
	},
})

-- keymaps
vim.keymap.set("n", "<leader>mr", ":Neotest run<cr>", { silent = true, desc = "Run nearest test" })
vim.keymap.set("n", "<leader>ms", ":Neotest summary<cr>", { silent = true, desc = "Test summary" })
vim.keymap.set("n", "<leader>mo", ":Neotest output<cr>", { silent = true, desc = "Test output" })
vim.keymap.set("n", "<leader>mp", ":Neotest output-panel<cr>", { silent = true, desc = "Test output panel" })
