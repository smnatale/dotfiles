return {
	"nvim-mini/mini.nvim",
	version = false,
	config = function()
		-- enhanced, a and i keybinds
		require("mini.ai").setup()

		-- auto pairs
		require("mini.pairs").setup()

		-- access to surround keymaps sa,sd,sc etc
		require("mini.surround").setup()

		-- icons, replace nvim_web_devicons
		require("mini.icons").setup()
		MiniIcons.mock_nvim_web_devicons()

		-- better jump capabilities
		require("mini.jump").setup()

		-- override vim.notify and show lsp info
		require("mini.notify").setup({
			lsp_progress = {
				enable = false,
			},
			content = {
				format = function(notif)
					return notif.msg
				end,
			},
			window = {
				config = function()
					local has_statusline = vim.o.laststatus > 0
					local pad = vim.o.cmdheight + (has_statusline and 1 or 0)

					return {
						border = "rounded",
						col = vim.o.columns,
						row = vim.o.lines - pad,
						anchor = "SE",
						title = "",
					}
				end,
			},
		})
		local orig = MiniNotify.make_notify()
		local str_to_level = { trace = 0, debug = 1, info = 2, warn = 3, error = 4, off = 5 }
		vim.notify = function(msg, level, opts)
			if type(level) == "string" then
				level = str_to_level[level:lower()] or vim.log.levels.INFO
			end
			return orig(msg, level, opts)
		end
	end,
}
