return {
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {
      hl_group = "Substitute",
      show_message = true,
      save_in_cmdline_history = false,
      input_buffer_type = "dressing",
    },
    keys = {
      {
        "<leader>rr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        mode = "n",
        expr = true,
        desc = "Refactor: Incremental rename",
      },
    },
  },
}
