-- source and update neovim config
vim.keymap.set("n", "<leader>so", function()
	vim.cmd("update")
	vim.cmd("source $MYVIMRC")
end, { desc = "Source and update neovim config" })

-- restart nvim and restore session
local session_file = vim.fn.stdpath("state") .. "/Session.vim"
vim.keymap.set("n", "<leader>re", function()
	vim.cmd("mks! " .. vim.fn.fnameescape(session_file))
	vim.cmd("restart source " .. vim.fn.fnameescape(session_file))
end, { desc = "Restart nvim and restore session" })

-- Disable Space bar since it will be used as the leader key
vim.keymap.set({ "n", "v" }, "<leader>", "<nop>", { desc = "Disable leader key default" })

-- Redo remap
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- after a search, press escape to clear highlights
vim.keymap.set("n", "<Esc>", ":nohl<CR>", { desc = "Clear search highlights" })

-- Swap between split buffers
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { desc = "Move to right split" })
vim.keymap.set("n", "<leader>rr", ":wincmd r<CR>", { desc = "Rotate split buffers" })

-- Save and quit current file quicker
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = false, noremap = true, desc = "Save current file" })
vim.keymap.set({ "n", "t" }, "<leader>q", ":q<cr>", { silent = false, noremap = true, desc = "Quit current buffer" })

-- Little one from Primeagen to mass replace string in a file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { silent = false, desc = "Search and replace word under cursor" })

-- Navigate through buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = false, desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = false, desc = "Previous buffer" })

-- Close currently active buffer
vim.keymap.set("n", "<C-c>", ":bwipeout<CR>", { silent = false, desc = "Close current buffer" })

-- Center buffer when navigating up and down
vim.keymap.set("n", "<S-k>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<S-j>", "<C-d>zz", { desc = "Scroll down and center" })

-- Center buffer when progressing through search results
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Paste without replacing paste with what you are highlighted over
vim.keymap.set("n", "<leader>p", '"_dP', { desc = "Paste without replacing register" })

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Open buffer to the right
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical split" })

-- Move selection up and down
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Exit terminal with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { desc = "Exit terminal mode" })

-- open config file and run :Oil
vim.keymap.set("n", "<leader>config", function()
	vim.cmd(":e ~/.config/nvim/init.lua")
	vim.cmd(":Oil")
end, { desc = "Open neovim config" })

-- toggle inlayhints
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled")
end, { desc = "Toggle inlay hints" })

vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>ts", ":tab split<CR>", { desc = "Split to new tab" })
vim.keymap.set("n", "<leader><Tab>", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader><S-Tab>", ":tabprevious<CR>", { desc = "Previous tab" })
