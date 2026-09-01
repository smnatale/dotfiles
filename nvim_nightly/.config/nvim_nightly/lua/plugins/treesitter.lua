local languages = {
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
}

local installed = require("nvim-treesitter.config").get_installed()
local treesitter = require("nvim-treesitter")

treesitter.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

treesitter.install(vim.iter(languages)
	:filter(function(language)
		return not vim.tbl_contains(installed, language)
	end)
	:totable())

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Update Tree-sitter parsers after plugin updates",
	group = vim.api.nvim_create_augroup("nvim_treesitter_update", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			vim.cmd("TSUpdate")
		end
	end,
})
