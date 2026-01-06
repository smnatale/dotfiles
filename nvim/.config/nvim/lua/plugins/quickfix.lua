return {
	"stevearc/quicker.nvim",
	ft = "qf",
	---@type quicker.SetupOptions
	opts = {},
	keys = {
		{
			">",
			function()
				require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
			end,
		},
		{
			"<",
			function()
				require("quicker").collapse()
			end,
		},
	},
}
