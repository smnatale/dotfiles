-- Base config from tokyonight but overrides every color
-- will at some point make into its own plugin
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = {
          enabled = false,
          scope_color = "sapphire",
          colored_indent_levels = false,
        },
        mason = true,
        native_lsp = { enabled = true },
        notify = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
      },
    },
    config = function()
      require("tokyonight").setup({
        styles = { floats = "transparent" },
        --   on_colors = function(colors)
        --     colors.bg = "#161821"
        --     colors.bg_dark = "#161821"
        --     colors.bg_dark1 = "#0f111d"
        --     colors.bg_highlight = "#1e2132"
        --     colors.bg_float = "#161821"
        --     colors.bg_popup = "#161821"
        --     colors.bg_search = "#4a6ab6"
        --     colors.bg_sidebar = "#181a22"
        --     colors.bg_statusline = "#181a22"
        --     colors.bg_visual = "#33415e"
        --     colors.black = "#191a22"
        --     colors.blue = "#8eaee0"
        --     colors.blue0 = "#4a6ab6"
        --     colors.blue1 = "#3ab8d3"
        --     colors.blue2 = "#1ea8c7"
        --     colors.blue5 = "#a3d3f8"
        --     colors.blue6 = "#c5eef0"
        --     colors.blue7 = "#4b5f88"
        --     colors.border = "#191a22"
        --     colors.border_highlight = "#3a94a9"
        --     colors.comment = "#656f91"
        --     colors.cyan = "#8bd9f6"
        --     colors.dark3 = "#606a8e"
        --     colors.dark5 = "#7d86b0"
        --     colors.diff = {
        --       add = "#2c3d48",
        --       change = "#262a3d",
        --       delete = "#4b2c38",
        --       text = "#4b5f88"
        --     }
        --     colors.error = "#ff8095"
        --     colors.fg = "#c8d3f5"
        --     colors.fg_dark = "#b0b9e3"
        --     colors.fg_float = "#c8d3f5"
        --     colors.fg_gutter = "#4b5374"
        --     colors.fg_sidebar = "#b0b9e3"
        --     colors.git = {
        --       add = "#50a7b8",
        --       change = "#7192c2",
        --       delete = "#a35a64",
        --       ignore = "#606a8e"
        --     }
        --     colors.green = "#a7d98c"
        --     colors.green1 = "#83e3cc"
        --     colors.green2 = "#4fb2c5"
        --     colors.hint = "#27cab6"
        --     colors.info = "#1ea8c7"
        --     colors.magenta = "#a093c7"
        --     colors.magenta2 = "#ff5fa3"
        --     colors.none = "NONE"
        --     colors.orange = "#ffb27d"
        --     colors.purple = "#b19cdf"
        --     colors.rainbow = { "#8eaee0", "#ffbe7d", "#a7d98c", "#27cab6", "#a093c7", "#b19cdf", "#ffb27d", "#ff8095" }
        --     colors.red = "#ff9aa8"
        --     colors.red1 = "#ff8095"
        --     colors.teal = "#27cab6"
        --     colors.terminal = {
        --       black = "#191a22",
        --       black_bright = "#4c5670",
        --       blue = "#8eaee0",
        --       blue_bright = "#a6c2ff",
        --       cyan = "#8bd9f6",
        --       cyan_bright = "#b5eaff",
        --       green = "#a7d98c",
        --       green_bright = "#b0f070",
        --       magenta = "#a093c7",
        --       magenta_bright = "#ada0d3",
        --       red = "#ff9aa8",
        --       red_bright = "#ff9aa8",
        --       white = "#b0b9e3",
        --       white_bright = "#c8d3f5",
        --       yellow = "#ffbe7d",
        --       yellow_bright = "#ffca5c"
        --     }
        --     colors.terminal_black = "#4c5670"
        --     colors.todo = "#8eaee0"
        --     colors.warning = "#ffbe7d"
        --     colors.yellow = "#ffbe7d"
        --   end,
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
