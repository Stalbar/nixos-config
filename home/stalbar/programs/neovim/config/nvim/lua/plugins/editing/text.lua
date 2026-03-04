return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
          enable_autocmd = false,
        },
      },
    },
    opts = function()
      local ok, ts_integ = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return {
        padding = true,
        sticky = true,
        ignore = "^$",
        pre_hook = ok and ts_integ.create_pre_hook() or nil,
      }
    end,
    config = function(_, opts)
      local comment = require("Comment")
      local api = require("Comment.api")
      comment.setup(opts)

      vim.keymap.set("n", "<leader>/", api.toggle.linewise.current, {
        desc = "Comment: Toggle line",
      })

      vim.keymap.set("x", "<leader>/", function()
        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        vim.api.nvim_feedkeys(esc, "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end, {
        desc = "Comment: Toggle selection",
      })

      vim.keymap.set("n", "<leader>?", api.toggle.blockwise.current, {
        desc = "Comment: Toggle block",
      })

      vim.keymap.set("x", "<leader>?", function()
        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        vim.api.nvim_feedkeys(esc, "nx", false)
        api.toggle.blockwise(vim.fn.visualmode())
      end, {
        desc = "Comment: Toggle block selection",
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      disable_filetype = { "TelescopePrompt", "neo-tree" },
    },
    config = function(_, opts)
      local ap = require("nvim-autopairs")
      ap.setup(opts)

      local ok_cmp, cmp = pcall(require, "cmp")
      if not ok_cmp then
        return
      end

      local ok_cmp_ap, cmp_ap = pcall(require, "nvim-autopairs.completion.cmp")
      if not ok_cmp_ap then
        return
      end

      cmp.event:on("confirm_done", cmp_ap.on_confirm_done())
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signcolumn = true,
      numhl = false,
      linehl = false,
      current_line_blame = false,
      attach_to_untracked = false,
      update_debounce = 120,
      preview_config = {
        border = "rounded",
      },
    },
    keys = {
      { "]h", function() require("gitsigns").next_hunk() end, desc = "Git: Next hunk" },
      { "[h", function() require("gitsigns").prev_hunk() end, desc = "Git: Prev hunk" },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Git: Preview hunk" },
      { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Git: Reset hunk" },
      { "<leader>gb", function() require("gitsigns").blame_line({ full = false }) end, desc = "Git: Blame line" },
    },
  },
}
