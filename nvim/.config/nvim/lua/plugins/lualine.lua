return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				component_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_c = { { "filename", path = 1 } },
				lualine_b = { "branch", "diff" },
				lualine_x = { "filetype" },
				lualine_y = {
					{
						"diagnostics",
						sources = { "nvim_workspace_diagnostic" },
					},
				},
				lualine_z = {},
			},
			extensions = { "quickfix", "nvim-tree" },
		},
	},
}
