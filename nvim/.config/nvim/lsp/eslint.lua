local eslint_fix_all_group = vim.api.nvim_create_augroup("UserLspEslintFixAll", {})

return {
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
			client:request_sync("workspace/executeCommand", {
				command = "eslint.applyAllFixes",
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = vim.lsp.util.buf_versions[bufnr],
					},
				},
			}, nil, bufnr)
		end, {})

		vim.api.nvim_clear_autocmds({ group = eslint_fix_all_group, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = eslint_fix_all_group,
			buffer = bufnr,
			command = "LspEslintFixAll",
			desc = "Fix all ESLint issues before saving",
		})
	end,
}
