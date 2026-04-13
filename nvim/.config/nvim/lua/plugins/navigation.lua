vim.pack.add({
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/rachartier/tiny-code-action.nvim" },
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Build telescope-fzf-native after install/update",
	group = vim.api.nvim_create_augroup("fzf_native_build", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
			vim.notify("Building telescope-fzf-native...", vim.log.levels.INFO)
			local obj = vim.system({ "make" }, { cwd = ev.data.path }):wait()
			if obj.code == 0 then
				vim.notify("Building telescope-fzf-native done", vim.log.levels.INFO)
			else
				vim.notify("Building telescope-fzf-native failed", vim.log.levels.ERROR)
			end
		end
	end,
})

local bottom_pane_config = {
	layout_strategy = "bottom_pane",
	layout_config = {
		height = 0.4,
		prompt_position = "bottom",
	},
	border = true,
	sorting_strategy = "descending",
	hidden = true,
}

require("telescope").setup({
	defaults = bottom_pane_config,
	extensions = {
		fzf = {},
		["ui-select"] = {},
	},
	pickers = {
		live_grep = {
			file_ignore_patterns = { "node_modules", ".git" },
			additional_args = function(_)
				return { "--hidden" }
			end,
		},
		find_files = {
			file_ignore_patterns = { "node_modules", ".git" },
			hidden = true,
		},
	},
})
local fzf_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"
local fzf_lib = fzf_path .. "/build/libfzf.so"
if vim.uv.fs_stat(fzf_path) and not vim.uv.fs_stat(fzf_lib) then
	vim.notify("Building telescope-fzf-native...", vim.log.levels.INFO)
	local obj = vim.system({ "make" }, { cwd = fzf_path }):wait()
	if obj.code == 0 then
		vim.notify("Building telescope-fzf-native done", vim.log.levels.INFO)
	else
		vim.notify("Building telescope-fzf-native failed:\n" .. (obj.stderr or ""), vim.log.levels.ERROR)
	end
end
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>ah", function()
	harpoon:list():add()
end, { desc = "Add file to harpoon" })
vim.keymap.set("n", "<leader>h", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle harpoon menu" })
vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end, { desc = "Harpoon file 4" })
vim.keymap.set("n", "<leader>5", function()
	harpoon:list():select(5)
end, { desc = "Harpoon file 5" })

vim.keymap.set("n", "<leader>sf", ":Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>sg", ":Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>sh", ":Telescope help_tags<cr>", { desc = "Search help tags" })
vim.keymap.set("n", "<leader>sd", ":Telescope diagnostics<cr>", { desc = "Search diagnostics" })
vim.keymap.set("n", "<leader>sb", ":Telescope buffers<cr>", { desc = "Search buffers" })
vim.keymap.set("n", "<leader>sk", ":Telescope keymaps<cr>", { desc = "Search keymaps" })
