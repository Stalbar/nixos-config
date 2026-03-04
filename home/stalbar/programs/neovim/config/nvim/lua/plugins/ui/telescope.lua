return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    keys = {
      {
        "<leader>tf",
        function()
          require("telescope.builtin").find_files({ hidden = true, no_ignore = true, follow = true })
        end,
        desc = "Telescope: Find files",
      },
      {
        "<leader>tg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Telescope: Live grep",
      },
      {
        "<leader>tb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Telescope: Buffers",
      },
      {
        "<leader>th",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Telescope: Help tags",
      },
    },
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--no-ignore",
            "--glob",
            "!**/.git/*",
            "--glob",
            "!**/node_modules/*",
            "--glob",
            "!**/.next/*",
          },
          file_ignore_patterns = {
            "node_modules/",
            "%.next/",
          },
          prompt_prefix = "   ",
          selection_caret = "▍ ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
            width = 0.88,
            height = 0.72,
            preview_width = 0.55,
          },
          border = true,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          winblend = 8,
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = true,
            follow = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
