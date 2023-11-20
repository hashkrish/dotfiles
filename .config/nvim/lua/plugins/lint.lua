return {
  {
    "https://github.com/mfussenegger/nvim-lint",
    config = function()
      local vim = vim -- luacheck: ignore

      require("lint").linters_by_ft = {
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        lua = { "luacheck" },
        sh = { "shellcheck" },
        -- markdown = { "markdownlint" },
        yaml = { "yamllint" },
        json = { "jsonlint" },
        -- html = { "htmllint" },
        css = { "stylelint" },
        scss = { "stylelint" },
        sass = { "stylelint" },
        less = { "stylelint" },
        vue = { "eslint_d" },
        svelte = { "eslint_d" },
        python = { "flake8" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", {
        clear = true,
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          require("lint").try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>cl", function()
        require("lint").try_lint()
      end, { desc = "Lint current buffer" })
    end,
  },
}
