local g = vim.g
local keymap = vim.keymap

-- Leader/Local leader mapping
g.mapleader = ","
g.maplocalleader = ","

-- Move lines up or down with alt + j/k. Works only with MacOS.
keymap.set("n", "∆", ":m .+1<CR>==", { noremap = true, silent = true })
keymap.set("n", "˚", ":m .-2<CR>==", { noremap = true, silent = true })
keymap.set("i", "∆", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })
keymap.set("i", "˚", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })
keymap.set("v", "∆", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap.set("v", "˚", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Allow clipboard copy paste in neovim
keymap.set("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
keymap.set("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
keymap.set("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
keymap.set("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

-- Map Leader + s to save the file.
keymap.set("n", "<leader>s", "<cmd>write<cr>")

-- Select all text in current buffer
keymap.set("n", "<leader>a", ":keepjumps normal! ggVG<cr>")
