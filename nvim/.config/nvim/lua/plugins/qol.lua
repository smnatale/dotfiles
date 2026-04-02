vim.pack.add({
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
})

require("fidget").setup({})

require("lualine").setup({
	options = {
		component_separators = "",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_c = { { "filename", path = 1 } },
		lualine_b = { "branch", "diff" },
		lualine_x = { "filetype" },
		lualine_y = {
			{
				"diagnostics",
				sources = { "nvim_workspace_diagnostic" },
			},
		},
		lualine_z = {},
	},
	extensions = { "quickfix", "oil" },
})

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
