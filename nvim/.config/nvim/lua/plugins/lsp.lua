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
		"eslint",
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

			local opts = function(desc)
				return { buffer = ev.buf, silent = true, desc = desc }
			end
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
			vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts("Hover documentation"))
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Find references"))

			vim.keymap.set({ "n", "v" }, "<leader>ca", function()
				require("tiny-code-action").code_action()
			end, opts("Code action"))
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts("Format buffer"))

			vim.keymap.set("n", "<leader>d", function()
				vim.diagnostic.open_float({
					border = "rounded",
				})
			end, opts("Show diagnostics float"))
		end,
	}
)
