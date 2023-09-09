return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      lspconfig.pyright.setup({})
      lspconfig.tsserver.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.gopls.setup({})
      lspconfig.svelte.setup({})
    end,
    keys = {
      {
        "<leader>cf",
        "<Cmd>FormatLock<CR>",
        desc = "Format buffer",
      },
    },
  },
}
