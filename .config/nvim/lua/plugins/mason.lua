return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "css-lsp",
        "eslint-lsp",
        "html-lsp",
        "js-debug-adapter",
        "prettier",
        "pyright",
        "svelte-language-server",
        "tailwindcss-language-server",
        "typescript-language-server",
      },
    },
  },
}
