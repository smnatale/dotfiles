return {
	{
		"romgrk/barbar.nvim",
		opts = {
			icons = {
				separator = { left = "", right = "" },
				separator_at_end = false,
			},
			sidebar_filetypes = {
				NvimTree = true,
			},
		},
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function(_, opts)
			require("barbar").setup(opts)
		end,
	},
}
