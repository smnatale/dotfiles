vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
	{ src = "https://github.com/rachartier/tiny-code-action.nvim" },
})

vim.lsp.enable({ "lua_ls", "ts_ls", "jsonls", "yamlls", "gopls", "just" })

require("tiny-code-action").setup({
	picker = {
		"telescope",
		opts = {
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					width = 0.8,
					height = 0.8,
					preview_width = 0.5,
				},
			},
			sorting_strategy = "ascending",
			prompt_prefix = "",
			entry_prefix = "  ",
			prompt_title = false,
			results_title = false,
			preview_title = false,
		},
	},
	backend = "delta",
})

vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
