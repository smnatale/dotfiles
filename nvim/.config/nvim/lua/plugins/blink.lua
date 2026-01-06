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
      ["<CR>"] = { "accept", "fallback" },
      ["<S-Tab>"] = { "show" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
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
          score_offset = -1,
        },
      },
    },
  },
  config = function(_, opts)
    require("luasnip.loaders.from_vscode").load()
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
    require("blink.cmp").setup(opts)
  end,
}
