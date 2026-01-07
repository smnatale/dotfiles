local nvimTreeFocusOrToggle = function()
	local nvimTree = require("nvim-tree.api")
	local currentBuf = vim.api.nvim_get_current_buf()
	local currentBufFt = vim.api.nvim_get_option_value("filetype", { buf = currentBuf })
	if currentBufFt == "NvimTree" then
		nvimTree.tree.toggle()
	else
		nvimTree.tree.focus()
	end
end

local function edit_or_open()
	local api = require("nvim-tree.api")
	api.node.open.edit()
end

-- for screensharing etc
-- co-workers too freaked out by neovim and me zipping around
return {
	{
		"nvim-tree/nvim-tree.lua",
		lazy = true,
		keys = {
			{ "<leader>ft", nvimTreeFocusOrToggle },
		},
		opts = {
			update_focused_file = {
				enable = true,
			},
			renderer = {
				root_folder_label = false,
				icons = {
					git_placement = "signcolumn",
					glyphs = {
						git = {
							unstaged = "M",
							staged = "S",
							unmerged = "?",
							renamed = "R",
							deleted = "D",
							untracked = "UT",
							ignored = "I",
						},
					},
				},
			},
			on_attach = function(bufnr)
				vim.keymap.set("n", "<ESC>", nvimTreeFocusOrToggle, {
					buffer = bufnr,
					silent = true,
				})
				vim.keymap.set("n", "l", edit_or_open, { buffer = bufnr })
				vim.keymap.set("n", "<CR>", edit_or_open, { buffer = bufnr })
			end,
		},
		config = function(_, opts)
			require("nvim-tree").setup(opts)
		end,
	},
}
