-- plugins
vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
})

-- options
local lualine = require("lualine")
lualine.setup({
	options = {
		component_separators = "",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_c = { { "filename", path = 1 } },
		lualine_b = { "branch", "diff" },
		lualine_x = {
			{
				"filetype",
				cond = function()
					return vim.fn.reg_recording() == ""
				end,
			},
			{
				function()
					return "Recording @" .. vim.fn.reg_recording()
				end,
				cond = function()
					return vim.fn.reg_recording() ~= ""
				end,
				padding = 1,
			},
		},
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
