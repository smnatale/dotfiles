vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/refractalize/oil-git-status.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
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

require("oil").setup({
	win_options = {
		signcolumn = "yes:2",
	},
	view_options = {
		show_hidden = true,
	},
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

require("oil-git-status").setup({
	show_ignored = false,
})

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
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

vim.keymap.set("n", "<leader>e", ":Oil<CR>")
vim.keymap.set("n", "<leader>sf", ":Telescope find_files<cr>")
vim.keymap.set("n", "<leader>sg", ":Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>sh", ":Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>sd", ":Telescope diagnostics<cr>")
vim.keymap.set("n", "<leader>sb", ":Telescope buffers<cr>")
