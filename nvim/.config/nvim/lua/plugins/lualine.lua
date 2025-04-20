return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
				},
				sections = {
					lualine_a = {},
					lualine_c = { {
						"filename",
						path = 1,
					} },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_x = { "filetype" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
}
