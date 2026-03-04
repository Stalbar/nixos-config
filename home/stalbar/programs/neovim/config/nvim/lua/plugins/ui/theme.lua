return {
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_status_lines = true
      vim.g.nord_cursor_line_number_background = false

      vim.cmd.colorscheme("nord")

      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#3b4252" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#4c566a", bg = "#3b4252" })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#3b4252" })
      vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#eceff4", bg = "#5e81ac", bold = true })
    end,
  },
}
