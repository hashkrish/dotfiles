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
vim.keymap.set("x", "'", "<Plug>(nvim-surround-visual)", { desc = "surround visual" })

vim.keymap.del("n", "H")
vim.keymap.del("n", "L")

vim.keymap.set("n", "<A-h>", "<Cmd>bp<CR>", { desc = "previous buffer" })
vim.keymap.set("n", "<A-l>", "<Cmd>bn<CR>", { desc = "next buffer" })

-- vim.keymap.del("n", "<A-j>")
-- vim.keymap.del("n", "<A-k>")
--
-- vim.keymap.set("n", "<A-j>", "<C-w>p", { desc = "previous window" })
-- vim.keymap.set("n", "<A-k>", "<C-w>w", { desc = "next window" })

vim.keymap.set("n", "<A-J>", "<Cmd>resize -2<CR>", { desc = "resize -2" })
vim.keymap.set("n", "<A-K>", "<Cmd>resize +2<CR>", { desc = "resize +2" })
vim.keymap.set("n", "<A-H>", "<Cmd>vertical resize -2<CR>", { desc = "vertical resize -2" })
vim.keymap.set("n", "<A-L>", "<Cmd>vertical resize +2<CR>", { desc = "vertical resize +2" })
