require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
	float = {
		transparent = true,
	},
	no_bold = true,
	no_italic = true,
	custom_highlights = function(colors)
		return {
			LspInlayHint = { bg = colors.base, fg = colors.overlay0, italic = true },
			NotificationInfo = { bg = "NONE", fg = colors.text },
			NotificationWarning = { bg = "NONE", fg = colors.overlay2 },
			NotificationError = { bg = "NONE", fg = colors.red },
		}
	end,
})

vim.cmd("colorscheme catppuccin-mocha")
