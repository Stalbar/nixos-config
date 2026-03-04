return {
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      debounce_threshold = {
        rising = 40,
        falling = 160,
      },
      hide = {
        cursorline = true,
        only_win = false,
      },
      window = {
        margin = {
          vertical = 0,
          horizontal = 1,
        },
        padding = 0,
        placement = {
          horizontal = "right",
          vertical = "top",
        },
      },
      render = function(props)
        local devicons = require("nvim-web-devicons")
        local name = vim.api.nvim_buf_get_name(props.buf)
        local filename = (name ~= "" and vim.fn.fnamemodify(name, ":t")) or "[No Name]"
        local ft = vim.bo[props.buf].filetype
        local icon, icon_color = devicons.get_icon_color(filename, ft, { default = true })
        local modified = vim.bo[props.buf].modified and " ●" or ""

        return {
          { " " .. icon .. " ", guifg = icon_color },
          { filename, gui = vim.bo[props.buf].modified and "bold" or nil },
          { modified },
          { " " },
        }
      end,
    },
  },
}
