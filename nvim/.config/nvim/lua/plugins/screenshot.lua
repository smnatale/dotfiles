return {
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    main = "nvim-silicon",
    opts = {
      disable_defaults = false,
      -- turn on debug messages
      debug = true,
      font = "CaskaydiaCove Nerd Font=34;Noto Color Emoji",
      theme = "tokyonight",
      background = nil,
      background_image = nil,
      pad_horiz = 0,
      pad_vert = 0,
      no_round_corner = true,
      no_window_controls = false,
      no_line_number = false,
      -- here a function is used to return the actual source code line number
      line_offset = function(args)
        return args.line1
      end,
      -- the distance between lines of code
      line_pad = 0,
      -- the rendering of tab characters as so many space characters
      tab_width = 4,
      language = nil,
      -- language = function()
      -- 	return vim.bo.filetype
      -- end,
      -- language = function()
      -- 	return vim.fn.fnamemodify(
      -- 		vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
      -- 		":e"
      -- 	)
      -- end,
      shadow_blur_radius = 16,
      shadow_offset_x = 8,
      shadow_offset_y = 8,
      shadow_color = nil,

      -- whether to strip of superfluous leading whitespace
      gobble = true,
      -- a string to pad each line with after gobbling removed larger indents,
      num_separator = nil,
      to_clipboard = false,
      -- here a function is used to get the name of the current buffer
      window_title = function()
        return vim.fn.fnamemodify(
          vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
          ":p:."
        )
      end,
      wslclipboard = nil,
      wslclipboardcopy = nil,
      command = "silicon",
      -- here a function is used to create a file in the current directory
      output = function()
        return "/home/smnatale/Pictures/" .. os.date("!%Y-%m-%dT%H-%M-%SZ") .. "_code.png"
      end,
    }
  },
}
