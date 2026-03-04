return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {
      transient = true,
      debounceMs = 120,
      wrap = false,
      showCompactInputs = true,
      showInputsTopPadding = false,
      showInputsBottomPadding = false,
      resultsSeparatorLineChar = "─",
    },
    keys = {
      {
        "<leader>sr",
        function()
          require("grug-far").open({
            prefills = {
              search = vim.fn.expand("<cword>"),
            },
          })
        end,
        desc = "Search/Replace: Project",
      },
      {
        "<leader>sR",
        function()
          require("grug-far").open({
            prefills = {
              paths = vim.fn.expand("%:p:h"),
              search = vim.fn.expand("<cword>"),
            },
          })
        end,
        desc = "Search/Replace: Current dir",
      },
    },
  },
}
