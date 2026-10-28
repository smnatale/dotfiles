vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.ai" },
	{ src = "https://github.com/nvim-mini/mini.align" },
	{ src = "https://github.com/nvim-mini/mini.pairs" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
	{ src = "https://github.com/nvim-mini/mini.indentscope" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/nvim-mini/mini.jump" },
	{ src = "https://github.com/nvim-mini/mini.splitjoin" },
	{ src = "https://github.com/nvim-mini/mini.hipatterns" },
})

require("mini.ai").setup()

require("mini.align").setup()

require("mini.indentscope").setup({
	symbol = "│",
	draw = {
		animation = require("mini.indentscope").gen_animation.none(),
	},
})

-- auto pairs
require("mini.pairs").setup()

-- access to surround keymaps sa,sd,sc etc
require("mini.surround").setup()

-- icons, replace nvim_web_devicons
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- better jump capabilities
require("mini.jump").setup()

-- toggle formatting of brackets
require("mini.splitjoin").setup({
	mappings = {
		toggle = "<leader>m",
	},
})

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		hex_color = hipatterns.gen_highlighter.hex_color(),
		fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
		hack = { pattern = "HACK", group = "MiniHipatternsHack" },
		todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
		note = { pattern = "NOTE", group = "MiniHipatternsNote" },
	},
})
