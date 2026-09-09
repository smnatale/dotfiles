vim.pack.add({
	-- File navigation
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/refractalize/oil-git-status.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	"https://github.com/nvim-telescope/telescope-frecency.nvim",

	-- Appearance
	"https://github.com/rose-pine/neovim",
	"https://github.com/kevinhwang91/nvim-hlslens",
	"https://github.com/m4xshen/smartcolumn.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/mawkler/modicator.nvim",

	-- LSP, completion, and formatting
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/b0o/SchemaStore.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/rachartier/tiny-code-action.nvim",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/Saghen/blink.lib",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/mikavilpas/blink-ripgrep.nvim",
	"https://github.com/rafamadriz/friendly-snippets",

	-- Syntax and editing
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/wansmer/treesj",
	"https://github.com/abecodes/tabout.nvim",

	-- Diagnostics and command line
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/stevearc/quicker.nvim",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/artemave/workspace-diagnostics.nvim",

	-- Git
	"https://github.com/martindur/zdiff.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",

	-- Testing
	"https://github.com/nvim-neotest/neotest",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/antoinemadec/FixCursorHold.nvim",
	"https://github.com/fredrikaverpil/neotest-golang",

	-- Go tools
	"https://github.com/fredrikaverpil/godoc.nvim",
	"https://github.com/olexsmir/gopher.nvim",

	-- Developer utilities
	"https://github.com/chrisgrieser/nvim-chainsaw",
})

require("plugins.blink")
require("plugins.colorscheme")
require("plugins.diagnostics")
require("plugins.formatting")
require("plugins.git")
require("plugins.lsp")
require("plugins.lualine")
require("plugins.mini")
require("plugins.oil")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.misc")
require("plugins.golang")
require("plugins.quicker")
require("plugins.testing")
