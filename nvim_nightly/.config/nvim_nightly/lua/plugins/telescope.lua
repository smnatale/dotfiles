local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local send_selected_or_all_to_qflist = function(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	if #picker:get_multi_selection() > 0 then
		actions.send_selected_to_qflist(prompt_bufnr)
	else
		actions.send_to_qflist(prompt_bufnr)
	end
end

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-q>"] = send_selected_or_all_to_qflist,
			},
			n = {
				["<C-q>"] = send_selected_or_all_to_qflist,
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
		["ui-select"] = require("telescope.themes").get_dropdown({}),
	},
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("frecency")

vim.keymap.set("n", "<leader>sf", "<cmd>Telescope frecency workspace=CWD<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>sF", builtin.find_files, { desc = "Find all files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
