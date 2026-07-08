-- plugins
vim.pack.add({
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/rachartier/tiny-code-action.nvim",
})

-- options
local cmdline = require("tiny-cmdline")
cmdline.setup({
	on_reposition = cmdline.adapters.blink,
})

local code_action = require("tiny-code-action")
code_action.setup({
	picker = "buffer",
})
