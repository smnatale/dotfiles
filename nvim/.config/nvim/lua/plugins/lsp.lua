return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "rachartier/tiny-code-action.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    vim.lsp.enable({ "lua_ls", "ts_ls", "gopls", "eslint" })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>K", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        vim.keymap.set({ "n", "x" }, "<leader>ca", function()
          require("tiny-code-action").code_action()
        end, { noremap = true, silent = true })

        vim.keymap.set("n", "<leader>li", function()
          if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
            vim.lsp.buf.code_action({
              apply = true,
              ---@diagnostic disable-next-line: assign-type-mismatch
              context = { only = { "source.removeUnused.ts" }, diagnostics = {} },
            })
            vim.defer_fn(function()
              vim.lsp.buf.format({ timeout_ms = 10000 })
            end, 100) -- 100ms delay
          else
            vim.lsp.buf.format({ timeout_ms = 10000 })
          end
        end)

        vim.keymap.set("n", "<leader>k", function()
          vim.diagnostic.open_float({
            border = "rounded",
          })
        end, opts)
      end,
    })
  end,
}
