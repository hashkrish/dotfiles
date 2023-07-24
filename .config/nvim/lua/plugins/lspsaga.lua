return {
  {
    "glepnir/lspsaga.nvim",
    opts = {

      "glepnir/lspsaga.nvim",
      server_filetype_map = {
        javascript = "javascript",
        typescript = "typescript",
        html = "html",
        vue = "vue",
        python = "python",
      },
      request_timeout = 5000,
    },
    keys = {
      { "K", "<Cmd>Lspsaga hover_doc<CR>" },
      { "gd", "<Cmd>Lspsaga lsp_finder<CR>" },
      { "<C-k>", "<Cmd>Lspsaga signature_help<CR>" },
      { "gp", "<Cmd>Lspsaga peek_definition<CR>" },
    },
    enabled = false,
  },
}
