return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "ThePrimeagen/refactoring.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
        pickers = {
          find_files = {
            hidden = true
          }
        },
        defaults = {
          mappings = {
            i = {
              ["<C-S-h>"] = actions.move_selection_previous,
              ["<C-S-l>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-x>"] = actions.delete_buffer,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            "yarn.lock",
            ".git",
            ".sl",
            "_build",
            ".next",
            "dist",
          },
          hidden = true,
          extensions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown({}),
            },
          },
        },
      })

      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("refactoring")
    end,
  },
}
