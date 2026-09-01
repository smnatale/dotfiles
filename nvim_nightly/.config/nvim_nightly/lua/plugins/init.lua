vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
			if vim.fn.executable("make") == 1 then
				vim.system({ "make" }, { cwd = ev.data.path }):wait()
			end
		end
	end,
})

vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/refractalize/oil-git-status.nvim",
	"https://github.com/rose-pine/neovim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/b0o/SchemaStore.nvim",
	"https://github.com/rachartier/tiny-code-action.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/martindur/zdiff.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	{ src = "https://github.com/nvim-telescope/telescope-frecency.nvim", version = "1.2.2" },
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/Saghen/blink.lib",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/rafamadriz/friendly-snippets",
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
require("plugins.ui")
