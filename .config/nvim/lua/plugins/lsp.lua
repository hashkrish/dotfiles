return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      timeout_ms = 5000, -- timeout to prevent blocking
    },
    keys = {
      {
        "<leader>cf",
        "<Cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR>",
        desc = "Format buffer",
      },
    },
  },
}
