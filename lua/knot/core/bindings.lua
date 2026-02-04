-- Prevent Alt+Backspace from triggering Esc in insert mode
vim.keymap.set("i", "<M-BS>", "<C-w>", { noremap = true })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
--mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
--highlight_search
vim.keymap.set("n", "<esc>", ":nohl<CR>", { desc = "Clear search highlights" })
--split
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
--undo
vim.keymap.set("n", "U", "<C-r>", { desc = "Undo with U" })

--prime_sub_word_on_cursor(goated)
vim.keymap.set(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ silent = false, desc = "Substitute current word under cursor" }
)
--buff_nav
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = false })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = false })

--terminalmode->normalmode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- small terminal
-- from smnatale
--https://github.com/smnatale/nvim/blob/a5b1c7a82e1a3a8379a188435858fac69edd1d97/lua/config/keymaps.lua
-- Using folke Snacks for terminal

-- https://github.com/mohamad-supangat/nvim-lua/blob/master/lua/keymaps.lua
vim.keymap.set(
	"n",
	"<leader>cd",
	":cd %:p:h<CR>",
	{ noremap = true, silent = true, desc = "Change dir to current opened file" }
)

-- splits
vim.keymap.set("n", "<leader>-", "<cmd>sp<cr>", { desc = "split horizontally" })
vim.keymap.set("n", "<leader>|", "<cmd>vsp<cr>", { desc = "split vertically" })

vim.keymap.set(
	"v",
	"<BS>",
	'"_d',
	{ noremap = true, silent = true, desc = "Delete without cut /copy to buffer clipboard" }
)

-- delete word like in gtk apps
vim.keymap.set({ "i", "t" }, "<C-BS>", "<C-W>", { noremap = true, silent = true, desc = "delete word" })
