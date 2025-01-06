return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/tokyonight.nvim" },
	config = function()
		local harpoon_files = require("harpoon_files")

		require("lualine").setup({
			options = {
				theme = "tokyonight",
			},
			sections = {
				lualine_x = {
					{ harpoon_files.lualine_component },
				},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
