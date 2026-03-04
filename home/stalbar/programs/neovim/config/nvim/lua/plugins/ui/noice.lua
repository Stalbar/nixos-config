return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
      { "<leader>nn", "<cmd>Noice<CR>", desc = "Noice panel" },
      { "<leader>nh", "<cmd>Noice history<CR>", desc = "Noice history" },
      { "<leader>nl", "<cmd>Noice last<CR>", desc = "Noice last message" },
      { "<leader>nd", "<cmd>Noice dismiss<CR>", desc = "Dismiss notifications" },
    },
    opts = {
      notify = { enabled = true },
      lsp = {
        progress = { enabled = false },
        signature = { enabled = false },
        hover = { enabled = true },
        message = { enabled = true },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        },
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "search_count" },
          opts = { skip = true },
        },
      },
      views = {
        cmdline_popup = {
          border = { style = "rounded", padding = { 0, 1 } },
          position = { row = "38%", col = "50%" },
          size = { width = 60, height = "auto" },
          win_options = {
            winblend = 8,
          },
        },
        popupmenu = {
          border = { style = "rounded", padding = { 0, 1 } },
          win_options = {
            winblend = 8,
          },
        },
      },
    },
  },
}
