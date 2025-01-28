-----------------------------------------------------------
-- Normal Mode
-----------------------------------------------------------
vim.keymap.set("n", "<leader>", "<nop>") -- Disable Space bar since it'll be used as the leader key

vim.keymap.set("n", "U", "<C-r>") -- Redo remap

vim.keymap.set("n", "<C-Left>", ":wincmd l<CR>") -- Swap between split buffers
vim.keymap.set("n", "<C-Right>", ":wincmd h<CR>") -- Swap between split buffers

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false }) -- Save current file quicker
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false }) -- Quit current file quicker

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { silent = false }) -- Little one from Primeagen to mass replace string in a file

vim.keymap.set("n", "<S-Right>", ":bnext<CR>", { silent = false }) -- Navigate through buffers
vim.keymap.set("n", "<S-Left>", ":bprevious<CR>", { silent = false }) -- Navigate through buffers
vim.keymap.set("n", "<C-c>", ":bwipeout<CR>", { silent = false }) -- Close active buffer

vim.keymap.set("n", "<C-Up>", "<C-u>zz") -- Center buffer when navigating up
vim.keymap.set("n", "<C-Down>", "<C-d>zz") -- Center buffer when navigating down
vim.keymap.set("n", "n", "nzzzv") -- Center buffer when progressing through search results
vim.keymap.set("n", "n", "Nzzzv") -- Center buffer when progressing through search results

vim.keymap.set("n", "<leader>p", '"_dP') -- Paste without replacing paste with what you are highlighted over

vim.keymap.set("n", "<leader>y", '"+y') -- Yank to system clipboard
vim.keymap.set("v", "<leader>y", '"+y') -- Yank to system clipboard
vim.keymap.set("n", "<leader>Y", '"+Y') -- Yank to system clipboard

vim.keymap.set('n', '<leader>v', ':vsplit<CR>') -- Open buffer to the right

-----------------------------------------------------------
-- Visual Mode
-----------------------------------------------------------
vim.keymap.set("v", "<leader>", "<nop>") -- Disable Space bar since it'll be used as the leader key
vim.keymap.set("v", "<C-Down>", ":m '>+1<CR>gv=gv") -- Move selection down
vim.keymap.set("v", "<C-Up>", ":m '<-2<CR>gv=gv") -- Move selection up 

-----------------------------------------------------------
-- Plugin Keymaps
-----------------------------------------------------------
vim.keymap.set("n", "<leader>e", ":Oil --float<cr>", { silent = false }) -- Open file browser
vim.keymap.set("n", "<leader>sb", ":Telescope buffers<cr>") -- Search buffers
vim.keymap.set("n", "<leader>sf", ":Telescope find_files<cr>") -- Search files
vim.keymap.set("n", "<leader>sg", ":Telescope live_grep<cr>") -- Grep through current directory

vim.api.nvim_create_autocmd("LspAttach", { --  Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion triggered by <c-x><c-o>

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})
