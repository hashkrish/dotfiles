return {
  "github/copilot.vim",
  config = function()
    vim.api.nvim_set_keymap("i", "<M-;>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<C-;>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
  end,
}
