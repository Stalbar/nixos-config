return {
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      backend = { "telescope" },
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.84,
          height = 0.82,
          preview_width = 0.55,
          prompt_position = "top",
        },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        winblend = 8,
      },
    },
  },
}
