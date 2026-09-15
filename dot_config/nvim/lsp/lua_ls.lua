return {
	settings = {
		Lua = {
			hint = { enable = true },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
}
