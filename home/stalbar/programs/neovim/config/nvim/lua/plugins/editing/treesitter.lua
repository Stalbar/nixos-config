return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "bash",
        "nix",
        "json",
        "jsonc",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "dockerfile",
        "sql",
        "c_sharp",
      },
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_, buf)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > 1024 * 200
        end,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<BS>",
          node_decremental = "<S-BS>",
        },
      },
    },
    config = function(_, opts)
      local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        local lazy_ok, lazy = pcall(require, "lazy")
        if lazy_ok then
          pcall(lazy.load, { plugins = { "nvim-treesitter" } })
          ok, ts_configs = pcall(require, "nvim-treesitter.configs")
        end
      end

      if not ok then
        vim.schedule(function()
          vim.notify("nvim-treesitter not available; run :Lazy sync", vim.log.levels.WARN)
        end)
        return
      end

      ts_configs.setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      opts = {
        enable_rename = false,
      },
    },
  },
}
