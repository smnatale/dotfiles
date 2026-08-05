local biome_code_actions_group = vim.api.nvim_create_augroup("UserLspBiomeCodeActions", {})

return {
	on_attach = function(_client, bufnr)
		vim.api.nvim_clear_autocmds({ group = biome_code_actions_group, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = biome_code_actions_group,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.code_action({
					context = {
						only = {
							"source.fixAll.biome",
							"source.organizeImports.biome",
						},
					},
					apply = true,
				})
			end,
			desc = "Apply Biome code actions on save",
		})
	end,
}
