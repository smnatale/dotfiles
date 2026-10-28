vim.pack.add({
	{ src = "https://github.com/stevearc/quicker.nvim" },
})

vim.keymap.set("n", "<leader>co", function()
	require("quicker").toggle()
end)

require("quicker").setup({
	keys = {
		{
			">",
			function()
				require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
			end,
			desc = "Expand quickfix context",
		},
		{
			"<",
			function()
				require("quicker").collapse()
			end,
			desc = "Collapse quickfix context",
		},
	},
})
