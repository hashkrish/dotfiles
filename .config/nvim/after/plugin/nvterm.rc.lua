local status, nvterm = pcall(require, 'nvterm')
if (not status) then return end

nvterm.setup()

vim.keymap.set('n', '<Space>tt', function()
    require("nvterm.terminal").toggle "float"
end)
vim.keymap.set('n', '<Space>th', function()
    require("nvterm.terminal").toggle "horizontal"
end)
vim.keymap.set('n', '<Space>tv', function()
    require("nvterm.terminal").toggle "vertical"
end)
