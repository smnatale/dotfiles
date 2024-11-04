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
		config = function(_, opts)
			require("tokyonight").setup({
				-- Change the "hint" color to the "orange" color, and make the "error" color bright red
				on_colors = function(colors)
					colors.bg = "#11121d"
					colors.bg_dark = "#11121d"
				end,
			})
			vim.cmd.colorscheme("tokyonight-night")
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		end,
	},
}
