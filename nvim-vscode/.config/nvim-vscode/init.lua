---@diagnostic disable: undefined-global
-- plugins
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.ai" },
	{ src = "https://github.com/nvim-mini/mini.pairs" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
	{ src = "https://github.com/nvim-mini/mini.jump" },
})

require("mini.ai").setup() -- enhanced, a and i keybinds
require("mini.pairs").setup() -- auto pairs
require("mini.surround").setup() -- access to surround keymaps sa,sd,sc etc
require("mini.jump").setup() -- better jump capabilities

--
-- options
--
vim.g.mapleader = " " -- space leader key
vim.o.autoread = true -- auto update file if changed outside of nvim
vim.o.undofile = true -- persistant undo history
vim.o.cursorline = true -- enable cursor line
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
vim.o.wrap = false -- disable wrapping
vim.o.breakindent = true -- prevent line wrapping

--
-- keymaps
--
vim.keymap.set({ "n", "v" }, "<leader>", "<nop>") -- Disable Space bar since it will be used as the leader key
vim.keymap.set("n", "U", "<C-r>") -- Redo remap
vim.keymap.set("n", "<Esc>", ":nohl<CR>") -- after a search, press escape to clear highlights
vim.keymap.set("n", "<S-k>", "<C-u>zz") -- Center buffer when navigating up
vim.keymap.set("n", "<S-j>", "<C-d>zz") -- Center buffer when navigating down
-- Save and quit current file quicker
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set({ "n", "t" }, "<leader>q", "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>")
-- Swap between split buffers
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")
-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

--
-- lsp keymaps
--
vim.keymap.set("n", "<leader>gd", "<Cmd>lua require('vscode').action('editor.action.revealDefinitionAside')<CR>") -- Go to definition in side pane
vim.keymap.set("n", "<leader><space>", "<Cmd>lua require('vscode').action('editor.action.showHover')<CR>") -- Show hover
vim.keymap.set("n", "<leader>ca", "<Cmd>lua require('vscode').action('editor.action.quickFix')<CR>") -- Show code actions
vim.keymap.set("n", "<leader>gi", "<Cmd>lua require('vscode').action('editor.action.goToImplementation')<CR>") -- Go to implementation
vim.keymap.set("n", "<leader>gr", "<Cmd>lua require('vscode').action('editor.action.referenceSearch.trigger')<CR>") -- Go to references
vim.keymap.set("n", "<leader>rn", "<Cmd>lua require('vscode').action('editor.action.rename')<CR>") -- Rename symbol under cursor

--
-- vscode keymaps
--
-- vim.keymap.set("n", "<leader>sf", "<Cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>") -- search files
vim.keymap.set("n", "<leader>sf", "<Cmd>lua require('vscode').action('find-it-faster.findFiles')<CR>") -- search files
vim.keymap.set("n", "sf", "<Cmd>lua require('vscode').action('find-it-faster.findFilesWithType')<CR>") -- search files with type
vim.keymap.set("n", "<leader>sg", "<Cmd>lua require('vscode').action('find-it-faster.findInFiles')<CR>") -- search files in project
vim.keymap.set("n", "sg", "<Cmd>lua require('vscode').action('find-it-faster.findInFilesWithType')<CR>") -- search files in project with type
vim.keymap.set("n", "<leader>sp", "<Cmd>lua require('vscode').action('find-it-faster.resumeSearch')<CR>") -- search files in project
vim.keymap.set("n", "<Tab>", "<Cmd>lua require('vscode').action('workbench.action.nextEditor')<CR>") -- next tab
vim.keymap.set("n", "<S-Tab>", "<Cmd>lua require('vscode').action('workbench.action.previousEditor')<CR>") -- previous tab
vim.keymap.set("n", "<leader>e", "<Cmd>lua require('vscode').action('workbench.view.explorer')<CR>") -- open explorer
vim.keymap.set("n", "<leader>a", "<Cmd>lua require('vscode').action('workbench.action.toggleAuxiliaryBar')<CR>") -- open agent 
vim.keymap.set("n", "<leader>t", "<Cmd>lua require('vscode').action('workbench.action.togglePanel')<CR>") -- open terminal

--
-- autocommands
--
-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})