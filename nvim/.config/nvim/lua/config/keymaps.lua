-- Disable Space bar since it will be used as the leader key
vim.keymap.set({ "n", "v" }, "<leader>", "<nop>", { desc = "Disable leader key default" })

-- Redo remap
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- Swap between split buffers
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", {
	silent = true,
	desc = "Move to left split",
})
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true, desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", {
	silent = true,
	desc = "Move to above split",
})
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true, desc = "Move to right split" })
vim.keymap.set("n", "<leader>rr", ":wincmd r<CR>", { silent = true, desc = "Rotate split buffers" })
vim.keymap.set("n", "<leader>re", ":restart<CR>", { silent = true, desc = "Restart Neovim" })

local multicursor_ns = vim.api.nvim_create_namespace("nvim.multicursor")
vim.keymap.set("n", "<Esc>", function()
	vim.cmd.nohlsearch()
	vim.api.nvim_buf_clear_namespace(0, multicursor_ns, 0, -1)
end, { desc = "Clear search highligts & multicursors" })

-- Save and quit current file quicker
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true, noremap = true, desc = "Save current file" })
vim.keymap.set({ "n", "t" }, "<leader>q", ":q<cr>", { silent = true, noremap = true, desc = "Quit current buffer" })

-- Navigate through buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- Close currently active buffer
vim.keymap.set("n", "<C-c>", ":bwipeout<CR>", { silent = true, desc = "Close current buffer" })

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
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", { silent = true, desc = "Vertical split" })

-- Move selection up and down
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
