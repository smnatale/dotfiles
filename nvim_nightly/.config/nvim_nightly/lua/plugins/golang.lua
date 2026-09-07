vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "godoc.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
			vim.system({
				"go",
				"install",
				"github.com/lotusirous/gostdsym/stdsym@latest",
			}):wait()
		end
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	pattern = "*",
	callback = function(ev)
		if ev.data.spec.name == "gopher.nvim" and vim.tbl_contains({ "install", "update" }, ev.data.kind) then
			vim.cmd.GoInstallDeps()
		end
	end,
})

require("godoc").setup({})
require("gopher").setup({})

vim.keymap.set("n", "<leader>god", "<cmd>GoDoc<CR>", { silent = true })
