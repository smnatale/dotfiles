return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        disabled_filetypes = {
          statusline = {
            "",
          },
        },
      },
      sections = {
        lualine_a = {},
        lualine_c = { {
          "filename",
          path = 1,
        } },
        lualine_b = { "branch", "diff" },
        lualine_x = { "filetype" },
        lualine_y = {
          {
            "diagnostics",
            sources = { "nvim_workspace_diagnostic" },
          },
        },
        lualine_z = {},
      },
    },
  },
}
