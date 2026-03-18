local g = vim.g
local keymap = vim.keymap

-- Leader/Local leader mapping
g.mapleader = ','
g.maplocalleader = ','

-- Move lines up or down with alt + j/k. Works only with MacOS.
keymap.set('n', '∆', ':m .+1<CR>==', { noremap = true, silent = true, desc = 'Move line down' })
keymap.set('n', '˚', ':m .-2<CR>==', { noremap = true, silent = true, desc = 'Move line up' })
keymap.set(
  'i',
  '∆',
  '<Esc>:m .+1<CR>==gi',
  { noremap = true, silent = true, desc = 'Move line down' }
)
keymap.set(
  'i',
  '˚',
  '<Esc>:m .-2<CR>==gi',
  { noremap = true, silent = true, desc = 'Move line up' }
)
keymap.set(
  'v',
  '∆',
  ":m '>+1<CR>gv=gv",
  { noremap = true, silent = true, desc = 'Move selection down' }
)
keymap.set(
  'v',
  '˚',
  ":m '<-2<CR>gv=gv",
  { noremap = true, silent = true, desc = 'Move selection up' }
)

-- Allow clipboard copy paste in neovim
keymap.set('', '<D-v>', '+p<CR>', { noremap = true, silent = true, desc = 'Paste from clipboard' })
keymap.set('!', '<D-v>', '<C-R>+', { noremap = true, silent = true, desc = 'Paste from clipboard' })
keymap.set('t', '<D-v>', '<C-R>+', { noremap = true, silent = true, desc = 'Paste from clipboard' })
keymap.set('v', '<D-v>', '<C-R>+', { noremap = true, silent = true, desc = 'Paste from clipboard' })

-- Map Leader + s to save the file.
keymap.set('n', '<leader>s', '<cmd>write<cr>', { desc = 'Save file' })

-- Select all text in current buffer
keymap.set('n', '<leader>sa', ':keepjumps normal! ggVG<cr>', { desc = 'Select all' })

-- Resize windows
keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Better paste
keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking' })

-- Clear search highlighting
keymap.set('n', '<Esc>', '<cmd>noh<cr><Esc>', { desc = 'Clear search highlighting' })
