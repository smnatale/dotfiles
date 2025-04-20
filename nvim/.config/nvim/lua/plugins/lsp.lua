return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"artemave/workspace-diagnostics.nvim",
		},
		opts = {
			servers = {
				cssls = {},
				css_variables = {},
				ts_ls = {
					on_attach = function(client, bufnr)
						require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
					end,
				},
				eslint = {},
				tailwindcss = {},
				lua_ls = {
					settings = {
						Lua = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = {
								"vim",
								"require",
							},
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("mason").setup()

			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls", "lua_ls", "eslint" },
				automatic_installation = true,
			})

			require("workspace-diagnostics").setup({
				workspace_files = function()
					local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
					if not git_root or git_root == "" then
						return {}
					end

					local all_files = vim.fn.systemlist("git ls-files " .. git_root)

					local function should_include(file)
						if file:match("^node_modules/") then
							return false
						end
						if file:match("^%.[^/]+") then
							return false
						end -- top-level dotfiles/folders
						if file:match("/%.[^/]+") then
							return false
						end -- nested dotfiles/folders
						return true
					end

					local filtered_files = vim.tbl_filter(should_include, all_files)

					return filtered_files
				end,
			})

			local lspconfig = require("lspconfig")
			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function(_)
			require("conform").setup({
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					json = { "prettierd", "prettier", stop_after_first = true },
					graphql = { "prettierd", "prettier", stop_after_first = true },
				},
			})
		end,
	},
}
