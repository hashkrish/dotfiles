local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d.with({
      diagnostics_format = '[eslint] #{m}\n(#{c})'
    }),
    null_ls.builtins.diagnostics.fish,
    null_ls.builtins.diagnostics.alex,
    null_ls.builtins.diagnostics.cfn_lint,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.formatting.isort,
  }
})
