return {
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true,
			},
			renderer = {
				full_name = true,
				group_empty = true,
				special_files = {},
				symlink_destination = false,
				indent_markers = {
					enable = true,
				},
				icons = {
					git_placement = "signcolumn",
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
					modified_placement = "signcolumn",
					glyphs = {
						git = {
							unstaged = "U",
							staged = "A",
							unmerged = "M",
							renamed = "R",
							untracked = "?",
							deleted = "D",
							ignored = "!",
						},
					},
				},
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function(_, opts)
			require("nvim-tree").setup(opts)
		end,
	},
}
