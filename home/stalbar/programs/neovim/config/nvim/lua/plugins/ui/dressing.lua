return {
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        border = "rounded",
        win_options = {
          winblend = 8,
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder,FloatTitle:FloatTitle",
        },
      },
      select = {
        backend = { "builtin" },
        builtin = {
          border = "rounded",
          win_options = {
            winblend = 8,
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder,FloatTitle:FloatTitle",
          },
        },
      },
    },
  },
}
