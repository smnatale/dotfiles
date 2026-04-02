vim.pack.add({
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup({})
require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"prettierd",
		"eslint_d",
		"lua_ls",
		"tailwindcss-language-server",
		"ts_ls",
		"gopls",
		"sqls",
		"jsonls",
		"yamlls",
	},
	auto_update = false,
	run_on_start = true,
})

-- LspAttach keymaps
vim.api.nvim_create_autocmd(
	"LspAttach",
	{ --  Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion triggered by <c-x><c-o>

			local opts = { buffer = ev.buf }
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

			vim.keymap.set("n", "<leader>d", function()
				vim.diagnostic.open_float({
					border = "rounded",
				})
			end, opts)
		end,
	}
)
