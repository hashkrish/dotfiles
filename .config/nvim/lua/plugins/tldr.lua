return {
  {
    "mrjones2014/tldr.nvim",
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          vertical = { width = 0.9, height = 0.9 },
          -- other layout configuration here
        },
        -- other defaults configuration here
      },
      -- other configuration values here
      extensions = {
        tldr = {},
      },
    },
  },
}
