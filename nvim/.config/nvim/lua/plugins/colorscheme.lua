return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			transparent = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				illuminate = true,
				indent_blankline = {
					enabled = false,
					scope_color = "sapphire",
					colored_indent_levels = false,
				},
				mason = true,
				native_lsp = { enabled = true },
				notify = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
			},
		},
		config = function()
			require("tokyonight").setup({
				styles = { floats = "transparent" },
				on_colors = function(colors)
					colors.bg = "#090B10"
					colors.bg_dark = "#06070A"
					colors.bg_sidebar = "#06070A"
				end,
			})
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
}
