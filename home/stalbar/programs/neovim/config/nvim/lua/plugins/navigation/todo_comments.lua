return {
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      signs = true,
      highlight = {
        multiline = true,
        before = "",
        keyword = "wide",
        after = "fg",
      },
      keywords = {
        FIX = { icon = "󰅚", color = "error" },
        TODO = { icon = "󰗡", color = "info" },
        HACK = { icon = "󰈸", color = "warning" },
        WARN = { icon = "󰀪", color = "warning" },
        NOTE = { icon = "󰋽", color = "hint" },
      },
    },
    keys = {
      { "<leader>tD", "<cmd>TodoTelescope<CR>", desc = "Telescope: TODOs" },
      { "<leader>tQ", "<cmd>TodoQuickFix<CR>", desc = "Quickfix: TODOs" },
    },
  },
}
