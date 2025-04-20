return {
	{
		"stevearc/oil.nvim",
		opts = {
			view_options = {
				show_hidden = true,
			},
			float = {
				max_width = 0.8,
				max_height = 0.9,
			},
		},
		dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
		config = function(_, opts)
			local oil = require("oil")
			oil.setup(opts)
		end,
	},
}
