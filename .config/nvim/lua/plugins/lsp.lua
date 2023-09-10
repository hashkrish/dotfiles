return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "antosha417/nvim-lsp-file-operations", config = true,
      }
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      local keymap = vim.keymap

      local on_attach = function(client, bufnr)
        keymap.set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>",
          { desc = "Go to definition", noremap = true, silent = true, buffer = bufnr })
        keymap.set_keymap("n", "gD", vim.lsp.buf.declaration,
          { desc = "Go to declaration", noremap = true, silent = true, buffer = bufnr })
        keymap.set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>",
          { desc = "Go to references", noremap = true, silent = true, buffer = bufnr })
        keymap.set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>",
          { desc = "Go to implementation", noremap = true, silent = true, buffer = bufnr })
        keymap.set_keymap("n", "K", vim.lsp.buf.hover,
          { desc = "Show hover", noremap = true, silent = true, buffer = bufnr })
        keymap.set_keymap("n", "<leader>cr", vim.lsp.buf.rename,
          { desc = "Rename", noremap = true, silent = true, buffer = bufnr })
        keymap.set_keymap("n", "<leader>ca", vim.lsp.buf.code_action,
          { desc = "Code action", noremap = true, silent = true, buffer = bufnr })
        keymap.set_keymap("n", "<leader>cd", vim.lsp.diagnostic.show_line_diagnostics,
          { desc = "Show line diagnostics", noremap = true, silent = true, buffer = bufnr })
        -- keymap.set_keymap("n", "<leader>cn", vim.lsp.diagnostic.goto_next,
        --   { desc = "Go to next diagnostic", noremap = true, silent = true, buffer = bufnr })
        -- keymap.set_keymap("n", "<leader>cp", vim.lsp.diagnostic.goto_prev,
        --   { desc = "Go to previous diagnostic", noremap = true, silent = true, buffer = bufnr })
        -- keymap.set_keymap("n", "<leader>ce", vim.lsp.diagnostic.set_loclist,
        --   { desc = "Set loclist", noremap = true, silent = true, buffer = bufnr })
      end

      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })
      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.svelte.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.cssls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.yamlls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
      })
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

    end,
    keys = {
      { "<leader>cf", "<Cmd>FormatLock<CR>", desc = "Format buffer" },
      { "gd", "<Cmd>Telescope lsp_definitions<CR>", desc = "Go to definition" },
      { "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Go to declaration" },
      { "gr", "<Cmd>Telescope lsp_references<CR>", desc = "Go to references" },
      { "gi", "<Cmd>Telescope lsp_implementations<CR>", desc = "Go to implementation" },
      { "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", desc = "Show hover" },
      { "<leader>cr", "<Cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename" },
      { "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code action" },
      { "<leader>cd", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", desc = "Show line diagnostics" },
      { "<leader>cn", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", desc = "Go to next diagnostic" },
      { "<leader>cp", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", desc = "Go to previous diagnostic" },
    },
  },
}
