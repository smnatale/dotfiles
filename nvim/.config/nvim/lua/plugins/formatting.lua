vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/meanderingprogrammer/render-markdown.nvim" },
})

-- files that mark a project as using biome
local biome_config = {
	"biome.json",
	"biome.jsonc",
	".biome.json",
	".biome.jsonc",
}

-- use biome if the project has a biome config, else the given fallback
local function project_formatters(bufnr, fallback)
	if vim.fs.root(bufnr, biome_config) then
		return { "biome-check" }
	end
	return fallback
end

-- eslint_d then prettierd (eslint_d is skipped without an eslint config)
local function javascript_formatters(bufnr)
	return project_formatters(bufnr, { "eslint_d", "prettierd" })
end

local function prettier_or_biome(bufnr)
	return project_formatters(bufnr, { "prettierd" })
end

require("conform").setup({
	format_on_save = {
		timeout_ms = 8000,
		lsp_format = "fallback",
	},

	formatters_by_ft = {
		lua = { "stylua" },

		-- biome in biome projects, otherwise eslint_d + prettierd
		javascript = javascript_formatters,
		javascriptreact = javascript_formatters,
		typescript = javascript_formatters,
		typescriptreact = javascript_formatters,

		-- biome-aware so two tools don't fight over the same project
		json = prettier_or_biome,
		jsonc = prettier_or_biome,
		graphql = prettier_or_biome,
		css = prettier_or_biome,

		-- prettier only
		html = { "prettierd" },
		markdown = { "prettierd" },
		yaml = { "prettierd" },

		go = { "goimports", "gofumpt" },
		sh = { "shfmt" },
		sql = { "sql_formatter" },
	},

	formatters = {
		-- only run when an eslint config exists up the tree
		eslint_d = {
			require_cwd = true,
		},
		sql_formatter = {
			prepend_args = { "--language", "postgresql" },
		},
	},
})
