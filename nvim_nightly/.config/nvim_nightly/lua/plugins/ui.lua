local cmdline = require("tiny-cmdline")
cmdline.setup({
	on_reposition = cmdline.adapters.blink,
	width = { value = "70%" },
})

local code_action = require("tiny-code-action")
code_action.setup({
	picker = "buffer",
})

local fidget = require("fidget")
fidget.setup()
