return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "bash",
          "regex",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
          "jsonc",
          "yaml",
          "dockerfile",
          "graphql",
          "proto",
          "sql",
          "c_sharp",
          "qmljs",
          "markdown",
          "markdown_inline",
        },
        auto_install = true,
        highlight = {
          enable = true,
          disable = { "markdown" },
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
          disable = { "javascript", "typescript", "tsx" },
        },
        autopairs = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<BS>",
            node_decremental = "<S-BS>",
          },
        },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_rename = false,
        },
      })
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local rainbow = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow.strategy["global"],
          vim = rainbow.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterBlue",
          "RainbowDelimiterCyan",
          "RainbowDelimiterGreen",
          "RainbowDelimiterYellow",
          "RainbowDelimiterOrange",
          "RainbowDelimiterRed",
          "RainbowDelimiterViolet",
        },
      }
    end,
  },
}
