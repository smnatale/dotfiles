-- plugins
vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/windwp/nvim-ts-autotag",
})

-- options
require("conform").setup({
	format_on_save = {
		timeout_ms = 8000,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "biome-check", "prettierd" },
		javascriptreact = { "biome-check", "prettierd" },
		typescript = { "biome-check", "prettierd" },
		typescriptreact = { "biome-check", "prettierd" },
		graphql = { "prettierd" },
		go = { "goimports", "gofmt" },
		json = { "biome-check", "prettierd" },
		sql = { "sql_formatter" },
	},
	formatters = {
		sql_formatter = {
			prepend_args = { "--language", "postgresql" },
		},
		prettierd = {
			condition = function(_, ctx)
				return vim.fs.root(ctx.filename, { "biome.json" }) == nil
			end,
		},
	},
})

require("nvim-ts-autotag").setup()
