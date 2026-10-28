vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
	sections = {
		lualine_b = { "branch", "diff" },
		lualine_a = {},
		lualine_c = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = { "diagnostics" },
		lualine_z = {},
	},
})
