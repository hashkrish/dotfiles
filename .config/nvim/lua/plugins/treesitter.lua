return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc", "htmldjango" })
    end
    opts.incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-k>",
        node_incremental = "<c-k>",
        scope_incremental = "<c-s>",
        node_decremental = "<c-j>",
      },
    }
  end,
}
