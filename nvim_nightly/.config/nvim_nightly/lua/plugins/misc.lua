-- command line centered
local cmdline = require("tiny-cmdline")
cmdline.setup({
	on_reposition = cmdline.adapters.blink,
	width = {
		value = "70%",
	},
})

-- loading spinners
local fidget = require("fidget")
fidget.setup({})

-- show number eg [1/32] next to search result inline
require("hlslens").setup()

-- show column when width exceeds for a file
require("smartcolumn").setup()

-- allow easy logging of variables
local chainsaw = require("chainsaw")
chainsaw.setup({})
vim.keymap.set("n", "<leader>lg", chainsaw.variableLog, { desc = "Log variable" })

-- allow easy toggling code structure modes
local treesj = require("treesj")
treesj.setup({
	use_default_keymaps = false,
})
vim.keymap.set("n", "<leader>m", treesj.toggle)
