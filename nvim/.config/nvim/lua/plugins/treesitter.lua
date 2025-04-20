return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		event = { "BufEnter" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function(_, opts)
			local treesitter = require("nvim-treesitter.configs")

			treesitter.setup(opts)
		end,
		opts = {
			auto_install = true,
			ensure_installed = {
				"bash",
				"css",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"luadoc",
			},
			sync_install = false,
			highlight = {
				enable = true,
				disable = "help",
			},
			indent = {
				enable = true,
			},
			autopairs = {
				enable = true,
			},
		},
	},
}
