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
				on_colors = function(colors)
					colors.bg = "#000000"
					colors.bg_dark = "#000000"
					colors.bg_highlight = "#11121d"
				end,
				on_highlights = function(hl, c)
					hl.TelescopeNormal = {
						bg = c.bg_dark,
						fg = c.fg_dark,
					}
					hl.TelescopeBorder = {
						bg = c.bg_dark,
						fg = c.bg_highlight,
					}
					hl.TelescopePromptNormal = {
						bg = c.bg_dark,
					}
					hl.TelescopePromptBorder = {
						bg = c.bg_dark,
						fg = c.bg_highlight,
					}
					hl.TelescopePromptTitle = {
						bg = c.bg_dark,
						fg = "#7dcfff",
					}
					hl.TelescopePreviewTitle = {
						bg = c.bg_dark,
						fg = "#7dcfff",
					}
					hl.TelescopeResultsTitle = {
						bg = c.bg_dark,
						fg = "#7dcfff",
					}
				end,
			})
			vim.cmd.colorscheme("tokyonight-night")
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "FloatTitle", { bg = "none", fg = "#7dcfff" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#11121d" })
		end,
	},
}
