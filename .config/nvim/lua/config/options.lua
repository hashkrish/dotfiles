-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.shiftwidth = 4 -- number of spaces to use for autoindent
vim.opt.tabstop = 4 -- number of spaces that a <Tab> counts for
vim.opt.scrolloff = 0 -- minimum number of screen lines to keep above and below the cursor

-- highlights
-- vim.api.nvim_set_hl(0, "TodoBgTODO", { fg = "#333333", bg = "#0000ff" })

vim.g.copilot_autostart = 0 -- start copilot on startup
vim.g.gitblame_enabled = 0 -- disable git blame on startup
