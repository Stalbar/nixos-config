return {
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
      local animate = require("mini.animate")
      local use_tui_scroll = not vim.g.neovide

      return {
        cursor = { enable = false },
        resize = { enable = false },
        open = { enable = false },
        close = { enable = false },
        scroll = {
          enable = use_tui_scroll,
          timing = animate.gen_timing.quadratic({ duration = 110, unit = "total" }),
          subscroll = animate.gen_subscroll.equal(),
        },
      }
    end,
  },
}
