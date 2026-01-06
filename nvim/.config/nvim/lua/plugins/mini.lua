return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    -- enhanced, a and i keybinds
    require("mini.ai").setup()

    -- auto pairs
    require("mini.pairs").setup()

    -- access to surround keymaps sa,sd,sc etc
    require("mini.surround").setup()

    -- icons, replace nvim_web_devicons
    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()

    -- replace gitsigns
    require("mini.diff").setup({
      view = {
        style = "sign",
        signs = {
          add = "┃",
          change = "┃",
          delete = "_",
        },
      },
    })

    -- better jump capabilities
    require("mini.jump").setup()

    -- override vim.notify and show lsp info
    require("mini.notify").setup({
      content = {
        format = function(notif)
          return notif.msg
        end,
      },
      window = {
        config = function()
          local has_statusline = vim.o.laststatus > 0
          local pad = vim.o.cmdheight + (has_statusline and 1 or 0)

          return {
            border = "rounded",
            col = vim.o.columns,
            row = vim.o.lines - pad,
            anchor = "SE",
            title = "",
          }
        end,
      },
    })
    MiniNotify.make_notify()
  end,
}
