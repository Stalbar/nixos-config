return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({
            async = false,
            timeout_ms = 4000,
            lsp_fallback = true,
          })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        if vim.bo[bufnr].buftype ~= "" then
          return
        end
        return { timeout_ms = 2500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixfmt" },

        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        jsonc = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },

        python = { "ruff_format" },
        go = { "gofmt" },
        gomod = { "gofmt" },
        gowork = { "gofmt" },

        sh = { "shfmt" },
        bash = { "shfmt" },

        cs = { "csharpier" },

        sql = { "pg_format" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci", "-sr" },
        },
        ruff_format = {
          command = "ruff",
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
        pg_format = {
          command = "pg_format",
          args = { "--no-rcfile", "--spaces", "2", "-" },
          stdin = true,
        },
      },
    },
  },
}
