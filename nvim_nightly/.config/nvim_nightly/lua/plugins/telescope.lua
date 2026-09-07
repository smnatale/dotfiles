local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local code_action = require("tiny-code-action")

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Build telescope-fzf-native after install/update",
	group = vim.api.nvim_create_augroup("telescope_fzf_build", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
			if vim.fn.executable("make") == 1 then
				vim.system({ "make" }, { cwd = ev.data.path }):wait()
			end
		end
	end,
})

telescope.setup({
	defaults = {
		path_display = { "truncate", "filename_first" },
		mappings = {
			i = {
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
			n = {
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		frecency = {
			db_safe_mode = false,
			db_validate_threshold = 0,
			show_filter_column = false,
		},
		["ui-select"] = require("telescope.themes").get_dropdown({}),
	},
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("frecency")

code_action.setup({
	picker = {
		"telescope",
		opts = {
			layout_strategy = "horizontal",
		},
	},
})

local function project_root()
	return vim.fs.root(0, { ".git" }) or vim.fs.root(vim.fn.getcwd(), { ".git" }) or vim.fn.getcwd()
end

vim.keymap.set("n", "<leader>sf", function()
	telescope.extensions.frecency.frecency({ cwd = project_root(), workspace = "CWD", hidden = true })
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>sF", function()
	builtin.find_files({ cwd = project_root() })
end, { desc = "Find all files" })
vim.keymap.set("n", "<leader>sg", function()
	builtin.live_grep({ cwd = project_root() })
end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
