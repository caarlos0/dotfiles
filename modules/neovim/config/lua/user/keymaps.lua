local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- disable Ex mode, I always enter in it by mistake
keymap("n", "Q", "<Nop>", opts)

-- create and edit new buffer
keymap("n", "<leader>n", ":enew<CR>", opts)

-- quicklists
keymap("n", "<leader>co", ":copen<CR>", opts)
keymap("n", "<leader>cc", ":cclose<CR>", opts)
keymap("n", "[q", ":cprevious<CR>zz", opts)
keymap("n", "]q", ":cnext<CR>zz", opts)

-- Resize with arrows
keymap("n", "<A-Up>", ":resize +2<CR>", opts)
keymap("n", "<A-Down>", ":resize -2<CR>", opts)
keymap("n", "<A-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<A-Right>", ":vertical resize +2<CR>", opts)

-- buffer killing
keymap("n", "<leader>q", ":Bdelete<CR>", opts) -- delete current buffer
keymap("n", "<leader>bad", ":%bd!<cr>:intro<cr>", opts) -- delete all buffers
-- delete surrounding buffers, make sure to keep the cursor position
keymap("n", "<leader>bsd", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current = vim.fn.expand("%:p")
  vim.cmd("%bd")
  vim.cmd("e " .. current)
  vim.api.nvim_win_set_cursor(0, cursor)
  vim.cmd("zz")
end, opts)

-- save and quit
keymap("n", "<leader>w", ":write<CR>", opts)

-- paste over without replacing default register
keymap("n", "<leader>p", '"_dP', opts)

-- keep more or less in the same place when going next
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- keep more or less in the same place when going up/down
-- BUG: https://github.com/neovim/neovim/issues/28106
-- keymap("n", "<C-u>", "<C-u>zz", opts)
-- keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-o>", "<C-o>zz", opts)
keymap("n", "<C-i>", "<C-i>zz", opts)

-- move record macro to Q instead of q
keymap("n", "Q", "q", opts)
keymap("n", "q", "<Nop>", opts)

-- Insert empty blank line above/bellow
keymap("n", "]<Space>", "m`o<Esc>``", opts)
keymap("n", "[<Space>", "m`O<Esc>``", opts)

-- system clipboard integration
keymap("n", "<leader>y", '"+y', opts)
keymap("n", "<leader>Y", '"+Y', opts)

-- copy the current file path
keymap("n", "<leader>py", ':let @" = expand("%:p")<CR>', opts)

-- delete to blackhole
keymap("n", "<leader>d", '"_d', opts)
keymap("n", "<leader>D", '"_D', opts)

-- Insert --
-- in insert mode, adds new undo points after , . ! and ?.
keymap("i", "-", "-<c-g>u", opts)
keymap("i", "_", "_<c-g>u", opts)
keymap("i", ",", ",<c-g>u", opts)
keymap("i", ".", ".<c-g>u", opts)
keymap("i", "!", "!<c-g>u", opts)
keymap("i", "?", "?<c-g>u", opts)

-- alias quick jk/kj to esc
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- If I visually select words and paste from clipboard, don't replace my
-- clipboard with the selected word, instead keep my old word in the
-- clipboard
keymap("v", "p", '"_dP', opts)

-- system clipboard integration
keymap("v", "<leader>y", '"+y', opts)
keymap("v", "<leader>Y", '"+Y', opts)

-- delete to blackhole
keymap("v", "<leader>d", '"_d', opts)
keymap("v", "<leader>D", '"_D', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
