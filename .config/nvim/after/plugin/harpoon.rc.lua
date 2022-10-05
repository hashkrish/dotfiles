local status, harpoon = pcall(require, 'harpoon')
if (not status) then return end

vim.keymap.set('n', '<Leader>a', '<Cmd>:lua require("harpoon.mark").add_file()<CR>') -- Goto previous buffer
vim.keymap.set('n', ';h', '<Cmd>:lua require("harpoon.ui").toggle_quick_menu()<CR>') -- Goto next buffer
