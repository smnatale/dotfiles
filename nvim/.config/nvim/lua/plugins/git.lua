require("zdiff").setup()

vim.keymap.set("n", "<leader>zd", function()
	require("zdiff").open()
end, { desc = "Zdiff (uncommitted)" })
