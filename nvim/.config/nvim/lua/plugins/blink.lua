return {
	"Saghen/blink.cmp",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
	},
	---@type blink.cmp.Config
	opts = {
		snippets = { preset = "luasnip" },
		keymap = {
			preset = "default",
			["<Tab>"] = { "accept", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<S-Tab>"] = { "show" },
			["J"] = { "select_next", "fallback" },
			["K"] = { "select_prev", "fallback" },
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
				"lazydev",
				"lsp",
				"path",
				"snippets",
				"buffer",
				"copilot",
			},
			per_filetype = {
				sql = { "snippets", "dadbod", "buffer" },
			},
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				lsp = {
					score_offset = 90,
				},
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					async = true,
					score_offset = 100,
				},
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			},
		},
	},
	config = function(_, opts)
		require("luasnip.loaders.from_vscode").load()
		require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
		require("blink.cmp").setup(opts)
	end,
}
