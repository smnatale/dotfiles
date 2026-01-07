-- source and update neovim config
vim.keymap.set("n", "<leader>so", function()
	vim.cmd("update")
	vim.cmd("source $MYVIMRC")
end)

-- restart nvim and restore session
local session_file = vim.fn.stdpath("state") .. "/Session.vim"
vim.keymap.set("n", "<leader>re", function()
	vim.cmd("mks! " .. vim.fn.fnameescape(session_file))
	vim.cmd("restart source " .. vim.fn.fnameescape(session_file))
end)

-- Disable Space bar since it will be used as the leader key
vim.keymap.set({ "n", "v" }, "<leader>", "<nop>")

-- Redo remap
vim.keymap.set("n", "U", "<C-r>")

-- after a search, press escape to clear highlights
vim.keymap.set("n", "<Esc>", ":nohl<CR>")

-- Swap between split buffers
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")
vim.keymap.set("n", "<leader>rr", ":wincmd r<CR>")

-- Save and quit current file quicker
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = false, noremap = true })
vim.keymap.set({ "n", "t" }, "<leader>q", ":q<cr>", { silent = false, noremap = true })

-- Little one from Primeagen to mass replace string in a file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { silent = false })

-- Navigate through buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = false })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = false })

-- Close currently active buffer
vim.keymap.set("n", "<C-c>", ":bwipeout<CR>", { silent = false })

-- Center buffer when navigating up and down
vim.keymap.set("n", "<S-k>", "<C-u>zz")
vim.keymap.set("n", "<S-j>", "<C-d>zz")

-- Center buffer when progressing through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without replacing paste with what you are highlighted over
vim.keymap.set("n", "<leader>p", '"_dP')

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- Open buffer to the right
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")

-- Move selection up and down
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Exit terminal with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")

-- open config file and run :Oil
vim.keymap.set("n", "<leader>config", function()
	vim.cmd(":e ~/.config/nvim/init.lua")
	vim.cmd(":Oil")
end)

-- toggle inlayhints
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled")
end)

vim.keymap.set("n", "<leader>tn", ":tabnew<CR>")
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>")
vim.keymap.set("n", "<leader>ts", ":tab split<CR>")
vim.keymap.set("n", "<leader><Tab>", ":tabnext<CR>")
vim.keymap.set("n", "<leader><S-Tab>", ":tabprevious<CR>")
