if vim.g.neovide then
  return {
    {
      "folke/noice.nvim",
      enabled = false,
    },
  }
else
  return {}
end
