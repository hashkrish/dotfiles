local keymap = vim.keymap
keymap.set('n', '<Leader>R', '<ESC>w<CR><ESC>:source %<CR>') -- Reload with <Leader> + r

keymap.set('n', '+', '<C-a>') -- Increment
keymap.set('n', '-', '<C-x>') -- Decrement

keymap.set('v', '<SPACE>y', '"+y') -- Yank to system clipboard
keymap.set('n', '<SPACE>Y', ':Yanks<CR>') -- Yank to system clipboard
keymap.set('n', 'db', 'vb"_d') -- Delete a word backwards

keymap.set('n', '<C-a>', 'gg<S-v>G') -- Select all
keymap.set('n', '<C-x>', '') -- Unsetting C-x

keymap.set('n', 'te', ':tabedit<Return>', { silent = true }) -- New tab
keymap.set('n', 'tc', ':tabclose<Return>', { silent = true }) -- Close tab

keymap.set('n', '<M-Space>', '<Cmd>tabnext<CR>', { silent = true }) -- Switch to next tab
keymap.set('n', 'ss', ':split<Return><C-w>w', { silent = true }) -- Horizontal split
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { silent = true }) -- Vertical split
keymap.set('n', 'sn', ':bn<Return>', { silent = true }) -- Next buffer
keymap.set('n', 'sp', ':bp<Return>', { silent = true }) -- Previous buffer
keymap.set('n', 'sl', ':e#<Return>', { silent = true }) -- Previous buffer
keymap.set('n', 'sd', ':bd<Return>', { silent = true }) -- Delete window
keymap.set('n', 'sc', ':close<Return><C-w>w', { silent = true }) -- Close window
keymap.set('n', 'st', '<C-w>T', { silent = true }) -- Window to tab
keymap.set('n', '<Space><Space>', '<C-w>w') -- switch to next window
keymap.set('n', '<Space>W', '<C-w>W') -- switch to previous window
keymap.set('n', '<Space>l', '<C-w>p') -- switch to last accessed window
keymap.set('n', '<Leader>f', '<C-w>_<C-w>|') -- Zoom window
keymap.set('n', '<Leader>=', '<C-w>=') -- Resize window to equal
keymap.set('n', '||', '<Cmd>bp<CR>') -- Goto previous buffer
keymap.set('n', '\\\\', '<Cmd>bn<CR>') -- Goto next buffer

keymap.set('n', '<C-w><left>', '<C-w><') -- Resize window left
keymap.set('n', '<C-w><right>', '<C-w>>') -- Resize window right
keymap.set('n', '<C-w><up>', '<C-w>+') -- Resize window up
keymap.set('n', '<C-w><down>', '<C-w>-') -- Resize window down

keymap.set('n', '<Leader>w', '<ESC>:set wrap!<Return>') -- Toggle wrap
keymap.set('n', '<SPACE>c', '<ESC>:noh<Return>') -- Remove hightlights
keymap.set('v', '<SPACE>c', '<ESC>') -- Remove hightlights
keymap.set('i', '<C-j>', '<ESC>o') -- Add another line from insert mode
keymap.set('x', 's', ':s/') -- s to substitue from visual mode
-- keymap.set('n', '<Leader>e', '<Cmd>CocDiagnostics<CR>') -- Show errors
keymap.set('', '<F8>', '<Cmd>TagbarToggle<CR>') -- Toggle Tagbar
keymap.set('n', '\\b', '<ESC>_iimport pdb; pdb.set_trace();<ESC>')
keymap.set('n', '\\B', '<ESC>:s/import pdb; pdb.set_trace();//g<Return>')
keymap.set('n', 'zz', 'zR')

keymap.set('n', '<leader>e', ':!%<CR>')
keymap.set('n', '<leader>cd', function()
    local target_dir = string.gsub(vim.api.nvim_get_current_line(), '/?[^/]*$', '')
    vim.api.nvim_command('cd ' .. target_dir)
    print(target_dir)
end)
keymap.set('n', '<leader>ccd', ':cd ~<CR>')
keymap.set('n', '<leader>cdf', ':cd %:p:h<CR>')
