return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
      { "<leader>bc", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
    },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        indicator = { style = "none" },
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,
        hover = {
          enabled = false,
        },
        offsets = {
          { filetype = "neo-tree", text = "Explorer", text_align = "left", separator = true },
        },
      },
    },
  },
}
