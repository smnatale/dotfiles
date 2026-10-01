vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/refractalize/oil-git-status.nvim",
	"https://github.com/b0o/SchemaStore.nvim",
	"https://github.com/martindur/zdiff.nvim",
	"https://github.com/rachartier/tiny-cmdline.nvim",
})

require("plugins.colorscheme")
require("plugins.lsp")
require("plugins.formatting")
require("plugins.oil")
require("plugins.treesitter")
require("plugins.mini")
require("plugins.git")
