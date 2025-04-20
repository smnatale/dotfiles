return {
	{
		"stevearc/resession.nvim",
		opts = {
			extensions = {
				barbar = {},
			},
		},
		config = function(_, opts)
			local resession = require("resession")
			resession.setup(opts)

			local curr_dir = vim.fn.getcwd()
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.argc(-1) == 0 then
						resession.load(curr_dir, { silence_errors = true })
					end
				end,
				nested = true,
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					resession.save(curr_dir, { notify = false })
				end,
			})
		end,
	},
}
