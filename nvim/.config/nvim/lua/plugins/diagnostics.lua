vim.pack.add({
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})

require("tiny-inline-diagnostic").setup({
	preset = "classic",
	options = {
		use_icons_from_diagnostic = true,
		multilines = {
			enabled = true,
		},
	},
})
