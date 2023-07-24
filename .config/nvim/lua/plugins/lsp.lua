return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      timeout_ms = 5000, -- timeout to prevent blocking
      --
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
    -- config = function()
    --   local lspconfig = require("lspconfig")
    --   lspconfig.timeout_ms = 5000
    --   lspconfig.pyright.setup({})
    --   lspconfig.tsserver.setup({})
    --   lspconfig.svelte.setup({
    --     cmd = { "svelteserver", "--stdio" },
    --     filetypes = { "svelte" },
    --     init_options = {
    --       compilerOptions = {
    --         enableTsServerPlugin = true,
    --       },
    --     },
    --   })
    -- end,
    keys = {
      {
        "<leader>cf",
        "<Cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR>",
        desc = "Format buffer",
      },
    },
  },
}
