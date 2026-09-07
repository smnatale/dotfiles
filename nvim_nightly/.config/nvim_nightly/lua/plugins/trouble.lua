require("trouble").setup()

vim.keymap.set("n", "<leader>co", "<cmd>Trouble qflist toggle<cr>", {
	silent = true,
	desc = "Toggle quickfix list",
})
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cp", "<cmd>cprevious<cr>", {
	silent = true,
	desc = "Previous quickfix item",
})

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
