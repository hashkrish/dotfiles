local keymap = vim.keymap

-- Do not yank with x
keymap.set('n', 'x', '"_x')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'db', 'vb"_d')

-- Remove hightlights with double ESC
-- keymap.set('n', '<ESC><ESC>', ':noh<CR>')

-- Select all
-- keymap.set('n', '<C-a>' 'gg<S-v>G')

-- New tab
keymap.set('n', 'te', ':tabedit<Return>', { silent = true })
keymap.set('n', 'ss', ':split<Return><C-w>w', { silent = true })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { silent = true })

keymap.set('n', '<Space>', '<C-w>w')
-- keymap.set('n', , { silent = true})
-- keymap.set('n', , { silent = true})

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

-- Toggle wrap
keymap.set('', '<Leader>w', ':set wrap!<Return>')

-- Toggle Tagbar
keymap.set('', '<F8>', '<Cmd>TagbarToggle<CR><C-w>w')
