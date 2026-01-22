return {
	"b0o/incline.nvim",
	config = function()
		require("incline").setup({
			window = {
				padding = 0,
				margin = { horizontal = 1 },
			},
			render = function(props)
				local devicons = require("nvim-web-devicons")
				local helpers = require("incline.helpers")

				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if filename == "" then
					filename = "[No Name]"
				end
				local ft_icon, ft_color = devicons.get_icon_color(filename)
				local modified = vim.bo[props.buf].modified
				local bg_color = "#191724"

				return {
					{ "", guifg = bg_color },
					{
						ft_icon and { "", ft_icon, " ", guifg = ft_color } or "",
						"",
						{ filename, gui = modified and "bold,italic" or "bold", guifg = ft_color },
						"",
						guibg = bg_color,
					},
					{ "", guifg = bg_color },
				}
			end,
		})
	end,
}
