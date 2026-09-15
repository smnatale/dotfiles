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

local function toggle_go_test()
	local path = vim.fn.expand("%:p")
	local target

	if path:match("_test%.go$") then
		target = path:gsub("_test%.go$", ".go")
	elseif path:match("%.go$") then
		target = path:gsub("%.go$", "_test.go")
	else
		return
	end

	vim.cmd.edit(vim.fn.fnameescape(target))
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function(ev)
		vim.keymap.set("n", "<leader>gt", toggle_go_test, {
			buffer = ev.buf,
			desc = "Toggle Go test/implementation",
		})
	end,
})

vim.keymap.set("n", "<leader>god", "<cmd>GoDoc<CR>", { silent = true })
