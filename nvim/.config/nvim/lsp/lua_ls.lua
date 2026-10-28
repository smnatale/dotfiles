return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			hint = { enable = true },
			workspace = {
				library = vim.list_extend(vim.api.nvim_get_runtime_file("", true), {
					"${3rd}/love2d/library",
				}),
			},
		},
	},
}
