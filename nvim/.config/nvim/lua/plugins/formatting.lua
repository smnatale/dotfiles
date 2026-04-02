vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
})

require("conform").setup({
	format_on_save = {
		timeout_ms = 8000,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		graphql = { "prettierd" },
		go = { "goimports", "gofmt" },
		json = { "prettierd" },
		sql = { "sql_formatter" },
	},
	formatters = {
		sql_formatter = {
			prepend_args = { "--language", "postgresql" },
		},
	},
})

require("nvim-ts-autotag").setup()
