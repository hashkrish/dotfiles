return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = { "jmbuhr/otter.nvim", "nvim-treesitter/nvim-treesitter" },
    opts = {
      sources = {
        { name = "otter" },
      },
      debug = false,
      closePreviewOnExit = true,
      lspFeatures = {
        enabled = true,
        languages = { "r", "python", "julia", "bash" },
        chunks = "curly", -- 'curly' or 'all'
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      keymap = {
        hover = "K",
        definition = "gd",
      },
    },
  },
}
