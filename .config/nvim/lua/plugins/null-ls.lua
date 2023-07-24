return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      -- formatter
      table.insert(opts.sources, nls.builtins.formatting.prettier)
      -- table.insert(opts.sources, nls.builtins.formatting.prettierd)
      table.insert(opts.sources, nls.builtins.formatting.black)
      -- table.insert(opts.sources, nls.builtins.formatting.isort)
      table.insert(opts.sources, nls.builtins.formatting.djhtml)
      -- table.insert(opts.sources, nls.builtins.formatting.eslint_d)

      -- linter
      table.insert(opts.sources, nls.builtins.code_actions.eslint_d)
      -- ts server
      table.insert(opts.sources, nls.builtins.diagnostics.tsserver)
      table.insert(opts.sources, nls.builtins.code_actions.refactoring)
      table.insert(opts.sources, nls.builtins.code_actions.shellcheck)
      -- table.insert(opts.sources, nls.builtins.diagnostics.mypy)
      -- table.insert(opts.sources, nls.builtins.diagnostics.eslint_d)
      -- table.insert(opts.sources, nls.builtins.completion.spell)
      table.insert(opts.sources, nls.builtins.hover.dictionary)
      table.insert(opts.sources, nls.builtins.hover.printenv)
    end,
  },
}
