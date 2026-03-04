return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        poll_rate = 0,
        suppress_on_insert = true,
        ignore_done_already = true,
        ignore_empty_message = true,
        clear_on_detach = function(client_id)
          local client = vim.lsp.get_client_by_id(client_id)
          return client and client.name or nil
        end,
        display = {
          done_icon = "",
          progress_icon = { pattern = "dots", period = 0.8 },
          progress_style = "FidgetTask",
          group_style = "Title",
          icon_style = "Special",
        },
      },
      notification = {
        window = {
          normal_hl = "NormalFloat",
          winblend = 10,
          border = "rounded",
          x_padding = 1,
          y_padding = 0,
        },
      },
      integration = {
        ["nvim-tree"] = { enable = false },
        ["xcodebuild-nvim"] = { enable = false },
      },
    },
  },
}
