return {
  {
    "https://github.com/mhartington/formatter.nvim",
    event = "VeryLazy",
    config = function()
      local formatter = require("formatter")
      local prettier = require("formatter").prettier
      formatter.setup({
        logging = false,
        filetype = {
          python = {
            -- black
            function()
              return {
                exe = "black",
                args = { "--quiet", "-" },
                stdin = true,
              }
            end,
          },
          javascript = { prettier },
          javascriptreact = { prettier },
          typescript = { prettier },
          typescriptreact = { prettier },
          json = { prettier },
          html = { prettier },
          css = { prettier },
          scss = { prettier },
          sass = { prettier },
          less = { prettier },
          vue = { prettier },
          svelte = { prettier },
          lua = {
            function()
              vim.lsp.buf.format({ timeout_ms = 5000 })
            end,
          },
          markdown = {
            -- prettier
            function()
              return {
                exe = "prettier",
                args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
                stdin = true,
              }
            end,
          },
          yaml = {
            -- prettier
            function()
              return {
                exe = "prettier",
                args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
                stdin = true,
              }
            end,
          },
          ['*'] = {
            vim.lsp.buf.format({ timeout_ms = 5000 }),
          },
        },
      })
    end,
  }
}
