local servers = { "lua_ls", "ts_ls", "tailwindcss" }

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = servers,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({})
			end

			-- vim.api.nvim_create_autocmd("BufWritePre", {
			--   pattern = { "*.tsx", "*.ts" },
			--   callback = function()
			--     vim.lsp.buf.code_action({
			--       apply = true,
			--       context = {
			--         only = { "source.removeUnused.ts" },
			--         diagnostics = {},
			--       },
			--     })
			--   end,
			-- })
		end,
	},
}
