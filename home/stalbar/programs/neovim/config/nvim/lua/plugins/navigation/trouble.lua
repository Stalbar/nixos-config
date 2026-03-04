return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics: Trouble" },
      { "<leader>tq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix: Trouble" },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics: Trouble" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics: Buffer trouble" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix: Trouble" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Loclist: Trouble" },
      { "[x", "<cmd>Trouble prev skip_groups=true jump=true<CR>", desc = "Trouble: Previous item" },
      { "]x", "<cmd>Trouble next skip_groups=true jump=true<CR>", desc = "Trouble: Next item" },
    },
    opts = {
      auto_close = true,
      auto_open = false,
      auto_preview = false,
      focus = true,
      pinned = false,
      follow = true,
      win = {
        border = "rounded",
        size = 12,
      },
      keys = {
        ["q"] = "close",
        ["<esc>"] = "cancel",
      },
      icons = {
        indent = {
          top = "│ ",
          middle = "├╴",
          last = "└╴",
          fold_open = " ",
          fold_closed = " ",
          ws = "  ",
        },
      },
    },
  },
}
