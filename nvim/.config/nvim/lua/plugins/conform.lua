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
		javascript = { "biome", "prettierd" },
		javascriptreact = { "biome", "prettierd" },
		typescript = { "biome", "prettierd" },
		typescriptreact = { "biome", "prettierd" },
		graphql = { "prettierd" },
		go = { "goimports", "gofmt" },
		json = { "biome", "prettierd" },
		sql = { "sql_formatter" },
	},
	formatters = {
		sql_formatter = {
			prepend_args = { "--language", "postgresql" },
		},
		biome = {
			condition = function(_, ctx)
				return vim.fs.root(ctx.filename, { "biome.json" }) ~= nil
			end,
		},
		prettierd = {
			condition = function(_, ctx)
				return vim.fs.root(ctx.filename, { "biome.json" }) == nil
			end,
		},
	},
})

require("nvim-ts-autotag").setup()
