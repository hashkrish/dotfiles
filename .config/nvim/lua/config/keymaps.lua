-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<LEADER>gb", builtin.git_branches, { noremap = true, silent = true, desc = "branches" })
vim.keymap.set("n", "<LEADER>gt", builtin.git_stash, { noremap = true, silent = true, desc = "stash" })
vim.keymap.set("n", "<LEADER>sx", builtin.resume, { noremap = true, silent = true, desc = "resume telescope" })
vim.keymap.set("n", "<LEADER>uR", "<Cmd>set norelativenumber<CR>", { desc = "toggle relative number" })
