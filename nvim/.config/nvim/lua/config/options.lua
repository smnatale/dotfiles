vim.g.mapleader = " " -- space leader key
vim.o.mouse = "" -- disable mouse in nvim

vim.o.termguicolors = true -- enable 24-bit colors
vim.o.updatetime = 200 -- save swap file with 200ms debouncing
vim.o.autoread = true -- auto update file if changed outside of nvim
vim.o.undofile = true -- persistant undo history
vim.o.number = true -- enable line numbers
vim.o.relativenumber = true -- enable relative line numbers

vim.o.completeopt = "menu,menuone,noselect,preview" -- omnicomplete options for popup menu
vim.o.pumheight = 10 -- max height of completion menu
vim.o.winborder = "rounded" -- rounded border
vim.o.showmode = false -- disable showing mode below statusline

vim.o.cursorline = true -- enable cursor line
vim.o.signcolumn = "yes" -- always show sign column
vim.o.ignorecase = true -- case-insensitive search
vim.o.smartcase = true -- until search pattern contains upper case characters
vim.o.incsearch = true -- enable highlighting search in progress

vim.o.tabstop = 2 -- how many spaces tab inserts
vim.o.softtabstop = 2 -- how many spaces tab inserts
vim.o.shiftwidth = 2 -- controls number of spaces when using >> or << commands
vim.o.expandtab = true -- use appropriate number of spaces with tab
vim.o.smartindent = true -- indenting correctly after {
vim.o.autoindent = true -- copy indent from current line when starting new line
vim.o.scrolloff = 8 -- always keep 8 lines above/below cursor unless at start/end of file

vim.o.splitbelow = true -- better splitting
vim.o.splitright = true -- better splitting

vim.o.wrap = false -- disable wrapping
vim.o.breakindent = true -- prevent line wrapping

vim.diagnostic.config({ virtual_text = true }) -- inline diagnostics
