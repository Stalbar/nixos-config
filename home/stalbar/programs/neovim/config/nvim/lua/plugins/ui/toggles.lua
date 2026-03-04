return {
  {
    "folke/noice.nvim",
    optional = true,
    event = "VeryLazy",
    keys = {
      {
        "<leader>ue",
        function()
          local enabled = vim.diagnostic.is_enabled()
          vim.diagnostic.enable(not enabled)
          vim.notify("Diagnostics " .. (enabled and "disabled" or "enabled"), vim.log.levels.INFO)
        end,
        desc = "UI: Toggle diagnostics",
      },
      {
        "<leader>uv",
        function()
          local cfg = vim.diagnostic.config()
          local vt_enabled = cfg.virtual_text ~= false
          if vt_enabled then
            vim.g._diag_virtual_text_prev = cfg.virtual_text
            vim.diagnostic.config({ virtual_text = false })
          else
            vim.diagnostic.config({ virtual_text = vim.g._diag_virtual_text_prev or true })
          end
          vim.notify("Virtual text " .. (vt_enabled and "disabled" or "enabled"), vim.log.levels.INFO)
        end,
        desc = "UI: Toggle virtual text",
      },
      {
        "<leader>us",
        function()
          local cfg = vim.diagnostic.config()
          local signs_enabled = cfg.signs ~= false
          if signs_enabled then
            vim.g._diag_signs_prev = cfg.signs
            vim.diagnostic.config({ signs = false })
          else
            vim.diagnostic.config({ signs = vim.g._diag_signs_prev or true })
          end
          vim.notify("Diagnostic signs " .. (signs_enabled and "disabled" or "enabled"), vim.log.levels.INFO)
        end,
        desc = "UI: Toggle diagnostic signs",
      },
    },
  },
}
