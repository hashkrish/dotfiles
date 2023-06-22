-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

-- Disable autoformat for html files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "html" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "*.py", "sh" },
  callback = function()
    vim.o.shiftwidth = 4
    vim.o.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "lua" },
  callback = function()
    vim.o.shiftwidth = 2
    vim.o.tabstop = 2
  end,
})
