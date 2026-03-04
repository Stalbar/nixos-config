return {
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      stages = "fade_in_slide_out",
      timeout = 1800,
      fps = 60,
      render = "wrapped-compact",
      top_down = false,
      minimum_width = 28,
      max_width = function()
        return math.floor(vim.o.columns * 0.40)
      end,
      max_height = function()
        return math.floor(vim.o.lines * 0.20)
      end,
      background_colour = "#2e3440",
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "",
      },
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
}
