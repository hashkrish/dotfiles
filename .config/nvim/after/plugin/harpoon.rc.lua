local status, harpoon = pcall(require, 'harpoon')
if (not status) then return end

harpoon.setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 20,
    }
})

vim.keymap.set('n', '<SPACE>fa', '<Cmd>:lua require("harpoon.mark").add_file()<CR>') -- Goto previous buffer
vim.keymap.set('n', '<SPACE>h', '<Cmd>:lua require("harpoon.ui").toggle_quick_menu()<CR>') -- Goto next buffer
