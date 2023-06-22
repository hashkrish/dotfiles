-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<LEADER>gb", builtin.git_branches, { noremap = true, silent = true, desc = "branches" })
vim.keymap.set("n", "<LEADER>gt", builtin.git_stash, { noremap = true, silent = true, desc = "stash" })
vim.keymap.set("n", "<LEADER>uR", "<Cmd>set norelativenumber<CR>", { desc = "toggle relative number" })
vim.keymap.set("n", "<LEADER>l", "<Cmd>b#<CR>", { desc = "goto last buffer" })
vim.keymap.set("n", "<LEADER>L", "<Cmd>Lazy<CR>", { desc = "Lazy" })
vim.keymap.set("x", "<M-s>", "<Plug>(nvim-surround-visual)", { desc = "surround visual" })
