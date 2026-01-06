return {
	"rose-pine/neovim",
	name = "rose-pine",
	opts = {
		styles = {
			bold = false,
			italic = true,
			transparency = true,
		},
	},
	config = function(_, opts)
		require("rose-pine").setup(opts)
		vim.cmd("colorscheme rose-pine")
		vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "none", fg = "#6e6a86", italic = true })
	end,
}
