vim.pack.add({
	{ src = "https://github.com/rose-pine/neovim" },
})

require("rose-pine").setup({
	styles = {
		bold = false,
		italic = true,
		transparency = true,
	},
	highlight_groups = {
		LspInlayHint = { bg = "base", fg = "muted", italic = true },
		NotificationInfo = { bg = "none", fg = "text" },
		NotificationWarning = { bg = "none", fg = "subtle" },
		NotificationError = { bg = "none", fg = "love" },
	},
})

vim.cmd("colorscheme rose-pine")
