return {
	"artemave/workspace-diagnostics.nvim",
	config = function()
		require("workspace-diagnostics").setup({
			workspace_files = function()
				local gitPath = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
				if gitPath == nil or gitPath == "" then
					return {}
				end

				-- get all tracked files
				local all_files = vim.fn.split(vim.fn.system("git ls-files " .. gitPath), "\n")

				-- directories to ignore
				local ignore_dirs = { ".yarn", "node_modules", "dist", "build" }

				-- helper to check if file is inside an ignored dir
				local function is_ignored(file)
					for _, dir in ipairs(ignore_dirs) do
						if file:match("^" .. dir .. "/") then
							return true
						end
					end
					return false
				end

				-- filter out ignored directories
				local filtered_files = {}
				for _, file in ipairs(all_files) do
					if file ~= "" and not is_ignored(file) then
						table.insert(filtered_files, file)
					end
				end

				return filtered_files
			end,
		})
	end,
}
