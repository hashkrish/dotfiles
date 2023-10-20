return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local vim = vim -- luacheck: ignore
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          go = { "gofumpt" },
          svelte = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          graphql = { "prettier" },
          lua = { "stylua" },
          python = {
            -- "isort_me",
            "black",
          },
        },
        format_on_save = {
          lsp_fallback = true,
          async = true,
          timeout_ms = 1000,
        },
        formatters = {
          isort_me = {
            command = "isort",
            args = { "$FILENAME" },
            stdin = false,
          },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({
          lsp_fallback = true,
          async = true,
          timeout_ms = 5000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  -- {
  --   "https://github.com/mhartington/formatter.nvim",
  --   event = "VeryLazy",
  --   enable = false,
  --   config = function()
  --     local formatter = require("formatter")
  --     local prettier = require("formatter").prettier
  --     formatter.setup({
  --       logging = false,
  --       filetype = {
  --         python = {
  --           -- black
  --           function()
  --             return {
  --               exe = "black",
  --               args = { "--quiet", "-" },
  --               stdin = true,
  --             }
  --           end,
  --         },
  --         javascript = { prettier },
  --         javascriptreact = { prettier },
  --         typescript = { prettier },
  --         typescriptreact = { prettier },
  --         json = { prettier },
  --         html = { prettier },
  --         css = { prettier },
  --         scss = { prettier },
  --         sass = { prettier },
  --         less = { prettier },
  --         vue = { prettier },
  --         svelte = { prettier },
  --         lua = {
  --           function()
  --             vim.lsp.buf.format({ timeout_ms = 5000 })
  --           end,
  --         },
  --         markdown = {
  --           -- prettier
  --           function()
  --             return {
  --               exe = "prettier",
  --               args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
  --               stdin = true,
  --             }
  --           end,
  --         },
  --         yaml = {
  --           -- prettier
  --           function()
  --             return {
  --               exe = "prettier",
  --               args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
  --               stdin = true,
  --             }
  --           end,
  --         },
  --         ["*"] = {
  --           vim.lsp.buf.format({ timeout_ms = 5000 }),
  --         },
  --       },
  --     })
  --   end,
  -- },
}
