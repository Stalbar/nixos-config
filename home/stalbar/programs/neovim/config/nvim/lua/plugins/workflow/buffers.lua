return {
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
      {
        "<leader>bd",
        function()
          require("bufdelete").bufdelete(0, false)
        end,
        desc = "Buffer: Delete (keep window)",
      },
      {
        "<leader>bD",
        function()
          require("bufdelete").bufdelete(0, true)
        end,
        desc = "Buffer: Force delete",
      },
    },
  },
}
