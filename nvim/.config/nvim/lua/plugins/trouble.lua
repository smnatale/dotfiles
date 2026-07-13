-- plugins
vim.pack.add({
	"https://github.com/folke/trouble.nvim",
	"https://github.com/folke/todo-comments.nvim",
})

-- options
require("trouble").setup()
require("todo-comments").setup()

-- keymaps
vim.keymap.set("n", "<leader>tr", "<cmd>Trouble diagnostics toggle<cr>", { silent = true })
vim.keymap.set("n", "<leader>td", "<cmd>Trouble todo toggle<cr>", { silent = true })

-- auto open trouble quickfix list
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("TroubleQuickfix", { clear = true }),
	callback = function(ev)
		if vim.bo[ev.buf].buftype == "quickfix" then
			vim.schedule(function()
				pcall(vim.cmd.cclose)
				vim.cmd([[Trouble qflist open]])
			end)
		end
	end,
})
