return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "black",
        "prettier",
        "eslint-lsp",
        "js-debug-adapter",
        "typescript-language-server",
      },
    },
  },
}
