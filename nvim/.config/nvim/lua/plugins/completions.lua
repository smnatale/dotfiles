vim.pack.add({
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Build blink.cmp after install/update",
	group = vim.api.nvim_create_augroup("blink_build", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			vim.notify("Building blink.cmp...", vim.log.levels.INFO)
			local obj = vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
			if obj.code == 0 then
				vim.notify("Building blink.cmp done", vim.log.levels.INFO)
			else
				vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
			end
		end
	end,
})

require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
	snippets = { preset = "luasnip" },
	keymap = {
		preset = "default",
		["<Tab>"] = { "accept", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<S-Tab>"] = { "show" },
		["<S-j>"] = { "select_next", "fallback" },
		["<S-k>"] = { "select_prev", "fallback" },
	},
	completion = {
		menu = {
			auto_show = true,
			draw = {
				treesitter = { "lsp" },
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
		documentation = { auto_show = true },
	},
	signature = { enabled = true },
	fuzzy = { implementation = "lua" },
	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
		},
		per_filetype = {
			sql = { "lsp", "snippets", "buffer" },
		},
		providers = {
			lsp = {
				score_offset = 90,
			},
		},
	},
})
