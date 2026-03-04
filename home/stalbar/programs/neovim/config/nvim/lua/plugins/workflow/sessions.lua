return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
      need = 1,
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Session: Restore (cwd)",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Session: Restore last",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Session: Stop saving",
      },
    },
  },
  {
    "ahmedkhalf/project.nvim",
    event = "BufReadPre",
    opts = {
      manual_mode = true,
      detection_methods = { "pattern" },
      patterns = {
        ".git",
        "flake.nix",
        "package.json",
        "pnpm-lock.yaml",
        "yarn.lock",
        "pyproject.toml",
        "Cargo.toml",
        "go.mod",
        "requirements.txt",
        "*.sln",
        "*.csproj",
      },
      silent_chdir = false,
      scope_chdir = "tab",
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      local ok, telescope = pcall(require, "telescope")
      if ok then
        pcall(telescope.load_extension, "projects")
      end
    end,
    keys = {
      {
        "<leader>tp",
        function()
          local ok, telescope = pcall(require, "telescope")
          if ok and telescope.extensions and telescope.extensions.projects then
            telescope.extensions.projects.projects({})
          end
        end,
        desc = "Telescope: Projects",
      },
    },
  },
}
