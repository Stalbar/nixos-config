return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>ot", "<cmd>ToggleTerm direction=float<CR>", desc = "Open: Terminal float" },
      { "<leader>os", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Open: Terminal split" },
      { "<leader>ov", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Open: Terminal vsplit" },
      { "<leader>oT", "<cmd>ToggleTerm direction=tab<CR>", desc = "Open: Terminal tab" },
      { "<F12>", "<cmd>ToggleTerm direction=float<CR>", mode = { "n", "i", "t" }, desc = "Terminal: Toggle float" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 14
        end
        if term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      direction = "float",
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_mode = true,
      persist_size = true,
      close_on_exit = true,
      shade_terminals = false,
      float_opts = {
        border = "rounded",
        winblend = 8,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal: Normal mode" })
    end,
  },
}
