local win_config = function()
	local has_statusline = vim.o.laststatus > 0
	local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
	return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad, title = "", border = "none" }
end

require("mini.notify").setup({
	content = {
		format = function(notification)
			return notification.msg
		end,
	},
	lsp_progress = {
		enable = true,
		duration_last = 500,
	},
	window = {
		config = win_config,
		winblend = 100,
	},
})
