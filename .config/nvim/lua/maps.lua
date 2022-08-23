local keymap = vim.keymap
keymap.set('n', '<Leader>R', '<ESC>w<CR><ESC>:source %<CR>') -- Reload with <Leader> + r
keymap.set('n', '+', '<C-a>') -- Increment
keymap.set('n', '-', '<C-x>') -- Decrement
keymap.set('n', 'db', 'vb"_d') -- Delete a word backwards
keymap.set('n', '<C-a>', 'gg<S-v>G') -- Select all
keymap.set('n', '<C-x>', '') -- Unsetting C-x
keymap.set('n', 'te', ':tabedit<Return>', { silent = true }) -- New tab
keymap.set('n', 'tc', ':tabclose<Return>', { silent = true }) -- Close tab
keymap.set('n', 'ss', ':split<Return><C-w>w', { silent = true }) -- Horizontal split
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { silent = true }) -- Vertical split
keymap.set('n', 'sc', ':close<Return><C-w>w', { silent = true }) -- Close window
keymap.set('n', '<Space>', '<C-w>w') -- Space to switch window
keymap.set('n', '<S-Space>', '<C-w>W') -- Shift + Space to switch previous window
keymap.set('n', '<Leader>f', '<C-w>_<C-w>|') -- Zoom window
keymap.set('n', '<Leader>=', '<C-w>=') -- Resize window to equal
keymap.set('n', '\\\\', '<Cmd>bp<CR>') -- Goto previous buffer
keymap.set('n', '||', '<Cmd>bn<CR>') -- Goto next buffer
keymap.set('n', '<C-w><left>', '<C-w><') -- Resize window left
keymap.set('n', '<C-w><right>', '<C-w>>') -- Resize window right
keymap.set('n', '<C-w><up>', '<C-w>+') -- Resize window up
keymap.set('n', '<C-w><down>', '<C-w>-') -- Resize window down
keymap.set('n', '<Leader>w', '<ESC>:set wrap!<Return>') -- Toggle wrap
keymap.set('n', '<Leader>c', '<ESC>:noh<Return>') -- Remove hightlights
keymap.set('', '<F8>', '<Cmd>TagbarToggle<CR>') -- Toggle Tagbar
keymap.set('i', '<C-j>', '<ESC>o') -- Add another line from insert mode
keymap.set('x', 's', ':s/') -- s to substitue from visual mode
