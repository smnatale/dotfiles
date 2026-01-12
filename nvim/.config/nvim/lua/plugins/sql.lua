return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		"tpope/vim-dadbod",
		"kristijanhusak/vim-dadbod-completion",
	},
	keys = {
		{
			"<leader>sql",
			function()
				vim.cmd("tabnew")
				vim.cmd("DBUI")
			end,
		},
	},
	config = function()
		vim.g.db_ui_use_nerd_fonts = 1
	end,
}
