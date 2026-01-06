return {
	"stevearc/oil.nvim",
	lazy = false,
	keys = {
		{ "<leader>e", "<cmd>Oil<cr>" },
	},
	dependencies = {
		"refractalize/oil-git-status.nvim",
	},
	---@type oil.SetupOpts
	opts = {
		win_options = {
			signcolumn = "yes:2",
		},
		view_options = {
			show_hidden = true,
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)
		require("oil-git-status").setup({
			show_ignored = false,
		})
	end,
}
