vim.pack.add({
	-- colorscheme
	{ src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
	-- lsp configurations
	"https://github.com/neovim/nvim-lspconfig",
	-- treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",
	-- snippets to load
	"https://github.com/rafamadriz/friendly-snippets",
	-- formatting on save for linters/formatters
	"https://github.com/stevearc/conform.nvim",
	-- lots of qol things and core functionality
	"https://github.com/nvim-mini/mini.nvim",
	-- the goat file manager
	"https://github.com/stevearc/oil.nvim",
	-- add gitstatus to the goat file manager
	"https://github.com/refractalize/oil-git-status.nvim",
	-- auto load into jsonls and yamlls completions from SchemaStore
	"https://github.com/b0o/SchemaStore.nvim",
	-- diff viewer inspired by zed diff (multibuffer)
	"https://github.com/martindur/zdiff.nvim",
})

require("plugins.colorscheme")
require("plugins.lsp")
require("plugins.formatting")
require("plugins.oil")
require("plugins.treesitter")
require("plugins.mini")
require("plugins.git")
