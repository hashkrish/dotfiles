local status, indent_blankline = pcall(require, 'indent_blankline')
if (not status) then return end

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`

vim.opt.termguicolors = true
-- Default highlight colors
-- #e06c75
-- #e5c07b
-- #98c379
-- #56b6c2
-- #61afef
-- #c678dd

vim.cmd [[highlight IndentBlanklineIndent1 guifg=#cb4b16 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#b58900 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#719e07 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#2aa198 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#268bd2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#d33682 gui=nocombine]]

-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#586e75 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#839496 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent3 guifg=#eee8d5 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent4 guifg=#657b83 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent5 guifg=#93a1a1 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent6 guifg=#fdf6e3 gui=nocombine]]


vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    context_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
    space_char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
    },
    -- space_char_blankline = " ",
    show_current_context = true,
    -- show_current_context_start = true,
    -- show_current_context_start_on_current_line = true,
}
indent_blankline.setup {
  char = '┊', -- ┊
  show_trailing_blankline_indent = false,
}
