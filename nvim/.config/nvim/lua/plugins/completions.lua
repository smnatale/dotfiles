return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    'saghen/blink.cmp',
    version = '*',
    dependencies = { 'L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets' },
    opts = {
      snippets = { preset = 'luasnip' },
      keymap = {
        preset = 'default',
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono'
      },
      signature = { enabled = true },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
  }
}
