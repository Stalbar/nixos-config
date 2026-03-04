return {
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialNavToggle" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown" },
      layout = {
        default_direction = "right",
        min_width = 28,
        max_width = 36,
      },
      show_guides = true,
      filter_kind = false,
      close_automatic_events = { "unfocus" },
      highlight_on_hover = true,
      float = {
        border = "rounded",
        max_height = 0.85,
        max_width = 0.45,
      },
    },
    keys = {
      { "<leader>so", "<cmd>AerialToggle!<CR>", desc = "Symbols: Toggle outline" },
      { "<leader>sn", "<cmd>AerialNext<CR>", desc = "Symbols: Next" },
      { "<leader>sp", "<cmd>AerialPrev<CR>", desc = "Symbols: Previous" },
    },
  },
}
