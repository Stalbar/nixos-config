return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        backdrop = 100,
      },
      max_concurrent_installers = 2,
    },
  },
}
