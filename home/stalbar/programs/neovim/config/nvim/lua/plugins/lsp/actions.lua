return {
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      backend = { "telescope" },
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.84,
          height = function(picker, _, max_lines)
            local result_count = (picker.finder and picker.finder.results and #picker.finder.results) or 1
            local min_height = 8
            local max_height = math.floor(max_lines * 0.6)

            -- Horizontal layout uses 5 rows for prompt and borders, so size to the result list.
            return math.max(min_height, math.min(result_count + 5, max_height))
          end,
          preview_width = 0.55,
          prompt_position = "top",
        },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        winblend = 8,
      },
    },
  },
}
