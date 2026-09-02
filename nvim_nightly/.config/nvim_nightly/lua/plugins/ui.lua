local cmdline = require("tiny-cmdline")
cmdline.setup({
	on_reposition = cmdline.adapters.blink,
	width = { value = "70%" },
})

local fidget = require("fidget")
fidget.setup({})

require("hlslens").setup()

require("smartcolumn").setup()

local chainsaw = require("chainsaw")
chainsaw.setup({})

vim.keymap.set({ "n", "x" }, "<leader>lg", chainsaw.variableLog, { desc = "Log variable" })
