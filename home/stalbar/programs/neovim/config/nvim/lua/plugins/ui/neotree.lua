return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      { "<leader>ntt", "<cmd>Neotree toggle left<CR>", desc = "Toggle Neo-tree" },
      { "<leader>ntf", "<cmd>Neotree reveal left<CR>", desc = "Neo-tree: Reveal file" },
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
              local target_win = vim.api.nvim_get_current_win()
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype ~= "neo-tree" then
                  target_win = win
                  break
                end
              end
              vim.api.nvim_set_current_win(target_win)
              vim.cmd("edit " .. vim.fn.fnameescape(path))
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
        position = "left",
        width = 32,
        mappings = {
          ["<space>"] = "none",
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
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = false,
      },
    },
  },
}
