vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("telescope-fzf-native.nvim")
			end
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-frecency.nvim" },
})

require("telescope").setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				width = 0.8,
				height = 0.8,
				preview_width = 0.5,
				prompt_title = "",
				results_title = "",
				preview_title = "",
			},
		},
		path_display = { "filename_first" },
		sorting_strategy = "ascending",
		prompt_prefix = "",
		entry_prefix = "  ",
		prompt_title = false,
		results_title = false,
		preview_title = false,
	},
	pickers = {
		find_files = { prompt_title = "", results_title = "", preview_title = "" },
		live_grep = { prompt_title = "", results_title = "", preview_title = "" },
		buffers = { prompt_title = "", results_title = "", preview_title = "" },
		help_tags = { prompt_title = "", results_title = "", preview_title = "" },
		git_status = { prompt_title = "", results_title = "", preview_title = "" },
		diagnostics = { prompt_title = "", results_title = "", preview_title = "" },
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
		frecency = {
			show_filter_column = false,
			hide_current_buffer = true,
			preceding = "opened",
			prompt_title = "",
			results_title = "",
			preview_title = "",
		},
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("frecency")

vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { link = "FloatBorder" })

vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { silent = true })
vim.keymap.set(
	"n",
	"<leader>sr",
	'<cmd>Telescope frecency workspace=CWD path_display={"filename_first"}<cr>',
	{ silent = true }
)
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { silent = true })
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { silent = true })
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { silent = true })
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { silent = true })
vim.keymap.set("n", "<leader>su", "<cmd>Telescope git_status<cr>", { silent = true })
