return {
	{
		"stevearc/oil.nvim",
		opts = {
			view_options = {
				show_hidden = true,
			},
		},
		config = function(_, opts)
			local oil = require("oil")
			oil.setup(opts)
			vim.keymap.set("n", "-", oil.toggle_float, {})
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},
}
