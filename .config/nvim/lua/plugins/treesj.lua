return {
  "Wansmer/treesj",
  lazy = true,
  keys = {
    { "<space>m", "<Cmd>TSJToggle<CR>", desc = "Toggle Treesitter Join" },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    use_default_keymaps = false,
  },
  cmd = {
    "TSJToggle",
    "TSJSplit",
    "TSJJoin",
  },
}
