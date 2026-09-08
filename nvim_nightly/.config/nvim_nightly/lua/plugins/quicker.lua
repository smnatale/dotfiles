require("quicker").setup()

vim.keymap.set("n", "<leader>co", function()
	require("quicker").toggle()
end, {
	silent = true,
	desc = "Toggle quickfix list",
})
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cp", "<cmd>cprevious<cr>", {
	silent = true,
	desc = "Previous quickfix item",
})
