return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      { "<leader>ntt", "<cmd>Neotree toggle current<CR>", desc = "Toggle Neo-tree" },
      { "<leader>ntf", "<cmd>Neotree reveal current<CR>", desc = "Neo-tree: Reveal file" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      event_handlers = {
        {
          event = "file_added",
          handler = function(path)
            if type(path) ~= "string" or vim.fn.isdirectory(path) == 1 then
              return
            end
            vim.schedule(function()
              if vim.fn.filereadable(path) == 0 then
                return
              end
              vim.cmd("edit " .. vim.fn.fnameescape(path))
            end)
          end,
        },
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.schedule(function()
              if vim.bo.filetype ~= "neo-tree" then
                return
              end
              vim.wo.number = true
              vim.wo.relativenumber = true
              vim.wo.numberwidth = 4
            end)
          end,
        },
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            local win = args and args.winid
            if not win or not vim.api.nvim_win_is_valid(win) then
              return
            end
            vim.schedule(function()
              if not vim.api.nvim_win_is_valid(win) then
                return
              end
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype ~= "neo-tree" then
                return
              end
              vim.wo[win].number = true
              vim.wo[win].relativenumber = true
              vim.wo[win].numberwidth = 4
            end)
          end,
        },
      },
      default_component_configs = {
        indent = { padding = 0 },
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󰉖",
          default = "󰈔",
        },
        modified = { symbol = "●" },
      },
      window = {
        position = "current",
        mappings = {
          ["<space>"] = "none",
          ["-"] = "navigate_up",
          ["H"] = "navigate_up",
          ["."] = function(state)
            require("neo-tree.sources.filesystem.commands").set_root(state)
            require("neo-tree.sources.manager").set_cwd(state)
          end,
        },
      },
      filesystem = {
        bind_to_cwd = false,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = false,
      },
    },
  },
}
