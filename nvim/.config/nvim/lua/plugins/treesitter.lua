-- plugins
vim.pack.add({
	"https://github.com/romus204/tree-sitter-manager.nvim",
})

-- options
require("tree-sitter-manager").setup({
	ensure_installed = {
		"bash",
		"css",
		"diff",
		"go",
		"gomod",
		"gowork",
		"gosum",
		"graphql",
		"html",
		"javascript",
		"jsdoc",
		"json",
		"json5",
		"lua",
		"luadoc",
		"luap",
		"markdown",
		"markdown_inline",
		"query",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"yaml",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})
