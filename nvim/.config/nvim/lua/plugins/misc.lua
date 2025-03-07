return {
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    'b0o/incline.nvim',
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/tokyonight.nvim",
    },
    config = function()
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        hide = { cursorline = true },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ' ',
            { (ft_icon or '') .. ' ', guifg = ft_color,                          guibg = 'none' },
            ' ',
            { filename,               gui = modified and 'bold,italic' or 'bold' },
            ' ',
          }
        end,
      }
    end,
  },
}
