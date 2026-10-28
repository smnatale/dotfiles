vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/martindur/zdiff.nvim" },
})

require("gitsigns").setup()

vim.keymap.set("n", "<leader>zd", "<cmd>Zdiff<cr>")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "zdiff",
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }

		vim.keymap.set("n", "<CR>", "<cmd>ZdiffOpen<cr>", opts)
		vim.keymap.set("n", "<Tab>", "<cmd>ZdiffToggle<cr>", opts)
		vim.keymap.set("n", "R", "<cmd>ZdiffRefresh<cr>", opts)
		vim.keymap.set("n", "q", "<cmd>bdelete<cr>", opts)

		-- Switch between uncommitted changes and comparison against main.
		vim.keymap.set("n", "m", function()
			if vim.b.zdiff.base == "" then
				vim.cmd("Zdiff main")
			else
				vim.cmd("Zdiff")
			end
		end, opts)
	end,
})
