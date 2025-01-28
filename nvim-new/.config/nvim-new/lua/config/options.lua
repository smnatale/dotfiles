-----------------------------------------------------------
-- General
-----------------------------------------------------------
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = " " -- Set leader key to space

vim.opt.tabstop = 2 -- Number of spaces a tab represents
vim.opt.softtabstop = 2 -- Number of spaces a tab represents
vim.opt.expandtab = true -- Use appropriate when using indent command
vim.opt.shiftwidth = 2 -- Use appropriate when using indent command 

vim.opt.smartindent = true -- Indenting correctly after { etc
vim.opt.autoindent = true -- Copy indent from current line when starting new line
vim.opt.breakindent = true -- Prevent line wrapping

vim.opt.wrap = false -- Disable text wrap
vim.opt.updatetime = 50 -- Speeds up plugin wait time
vim.opt.undofile = true -- Persistant undo file history
-----------------------------------------------------------
-- UI Config
-----------------------------------------------------------
vim.opt.nu = true -- Enable line numbers
vim.opt.rnu = true -- Enable relative line numbers

vim.opt.showmode = false -- Disable showing the mode below the statusline
vim.opt.completeopt = { "menuone", "noselect" } -- Better completion experience

vim.opt.termguicolors = true -- Enable 24-bit color
vim.opt.signcolumn = 'yes' -- Enable the sign column to prevent the screen from jumping
vim.opt.cursorline = true -- Enable cursor line highlight
vim.opt.scrolloff = 8 -- Always keep 8 lines above/below cursor unless at start/end of file

vim.opt.splitbelow = true -- Better splitting
vim.opt.splitright = true -- Better splitting

vim.opt.lazyredraw = true -- Faster scrolling

vim.api.nvim_create_autocmd("textyankpost", { -- Highlight yank
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})
-----------------------------------------------------------
-- Search Config
-----------------------------------------------------------
vim.opt.incsearch = true -- Enable highlighting search in progress
vim.opt.hlsearch = false -- Disable showing highlight after search done
vim.opt.ignorecase = true -- Ignore case for searches
vim.opt.smartcase = true -- Ignore case for searches
