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
      map_cr = false,
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

      cmp.event:on("confirm_done", function(evt)
        local item = evt.entry and evt.entry:get_completion_item() or nil
        local is_snippet = item and item.insertTextFormat == 2

        local ft = vim.bo.filetype
        local kind = evt.entry and evt.entry:get_kind() or nil
        local is_methodish = kind == cmp.lsp.CompletionItemKind.Method
          or kind == cmp.lsp.CompletionItemKind.Function

        if is_snippet or (ft == "cs" and is_methodish) then
          return
        end

        cmp_ap.on_confirm_done()(evt)
      end)
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        names = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        tailwind = true,
        mode = "virtualtext",
        virtualtext = "■",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
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
