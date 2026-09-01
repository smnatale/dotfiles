vim.opt.termguicolors = true

require("rose-pine").setup({
	styles = {
		bold = false,
		italic = false,
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
