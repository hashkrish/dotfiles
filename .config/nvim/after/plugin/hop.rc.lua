local status, hop = pcall(require, 'hop')
if (not status) then return end

hop.setup({
    keys = 'asdfjkl;',
})

local hop = require('hop')

vim.api.nvim_command('highlight HopNextKey  guifg=#839496   guibg=none gui=none ctermfg=none cterm=bold')
vim.api.nvim_command('highlight HopNextKey1 guifg=#839496   guibg=none gui=none ctermfg=none cterm=bold')
vim.api.nvim_command('highlight HopNextKey2 guifg=#839496   guibg=none gui=none ctermfg=none cterm=bold')
-- vim.api.nvim_command('highlight HopUnmatched guifg=none guibg=none guisp=none ctermfg=none')

-- local directions = require('hop.hint').HintDirection
-- vim.keymap.set('n', 'f', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
-- end, {remap=true})
-- vim.keymap.set('n', 'F', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
-- end, {remap=true})
-- vim.keymap.set('n', 't', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
-- end, {remap=true})
-- vim.keymap.set('n', 'T', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
-- end, {remap=true})

-- vim.keymap.set('n', 'ff', '<Cmd>HopChar1CurrentLine<CR>')
-- vim.keymap.set('n', 'fw', '<Cmd>HopWord<CR>')
-- vim.keymap.set('n', 'fl', '<Cmd>HopLine<CR>')

vim.keymap.set('n', 'f', '<Cmd>HopWord<CR>')

