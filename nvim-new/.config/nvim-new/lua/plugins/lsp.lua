return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()

      require('mason-lspconfig').setup({
        ensure_installed = { 'ts_ls', 'lua_ls', 'eslint' },
        automatic_installation = true,
      })

      local lspconfig = require('lspconfig')

      lspconfig.ts_ls.setup({
        settings = {
          javascript = { format = { semicolons = "remove" } },
          typescript = { format = { semicolons = "remove" } },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false -- Disable tsserver formatting in favor of prettier
        end,
      })

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } }, -- Recognize `vim` as a global
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
          },
        },
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          require("none-ls.diagnostics.eslint_d")
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end,
  }
}
