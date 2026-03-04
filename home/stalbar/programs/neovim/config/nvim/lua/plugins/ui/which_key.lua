return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      win = {
        border = "rounded",
        padding = { 1, 2 },
        title = " Keybinds ",
        title_pos = "center",
        wo = {
          winblend = 8,
        },
      },
      icons = {
        breadcrumb = "",
        separator = "",
        group = " ",
      },
      show_help = true,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>t", group = "Telescope/Trouble/Test" },
        { "<leader>nt", group = "Neo-tree" },
        { "<leader>n", group = "Noice" },
        { "<leader>b", group = "Buffers" },
        { "<leader>w", group = "Windows" },
        { "<leader>u", group = "UI" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>g", group = "Git/Goto" },
        { "<leader>o", group = "Open" },
        { "<leader>q", group = "Sessions" },
        { "<leader>r", group = "Refactor" },
        { "<leader>s", group = "Search/Symbols" },
        { "<leader>x", group = "Trouble" },
      })
    end,
  },
}
