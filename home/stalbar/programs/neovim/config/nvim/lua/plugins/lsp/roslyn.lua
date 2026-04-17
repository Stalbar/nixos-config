return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "csproj", "sln", "slnx" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lsp = require("core.lsp")

      -- Configure the LSP server itself via vim.lsp.config for this plugin version.
      vim.lsp.config("roslyn", {
        on_attach = lsp.on_attach,
        capabilities = lsp.capabilities(),
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_types = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_types_for_lambdas_when_parameters_are_implicitly_typed = true,
          },
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
        },
      })

      require("roslyn").setup({
        filewatching = "roslyn",
        broad_search = true,
        lock_target = false,
      })
    end,
  },
}
