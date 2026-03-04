return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lsp = require("core.lsp")
      local qml_cmd = nil
      if vim.fn.executable("qmlls6") == 1 then
        qml_cmd = { "qmlls6" }
      elseif vim.fn.executable("qmlls") == 1 then
        qml_cmd = { "qmlls" }
      end

      local base = {
        on_attach = lsp.on_attach,
        capabilities = lsp.capabilities(),
        flags = { debounce_text_changes = 150 },
        autostart = true,
      }

      local has_new_api = vim.lsp ~= nil and vim.lsp.config ~= nil and type(vim.lsp.enable) == "function"
      local lspconfig = nil
      local lspconfig_configs = nil
      local lspconfig_util = nil

      if not has_new_api then
        local ok_lspconfig, mod = pcall(require, "lspconfig")
        if ok_lspconfig then
          lspconfig = mod
          lspconfig_util = mod.util
        end

        local ok_configs, cfgs = pcall(require, "lspconfig.configs")
        if ok_configs then
          lspconfig_configs = cfgs
        end
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim", "require" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        bashls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
              },
            },
          },
        },
        ruff = {},
        ts_ls = {
          root_dir = lspconfig_util and lspconfig_util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")
            or nil,
          single_file_support = true,
          init_options = {
            hostInfo = "neovim",
            maxTsServerMemory = 1536,
          },
        },
        html = {},
        cssls = {},
        jsonls = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        dockerls = {},
        tailwindcss = {
          flags = {
            debounce_text_changes = 350,
          },
          single_file_support = false,
          filetypes = {
            "html",
            "css",
            "scss",
            "sass",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
          },
          settings = {
            tailwindCSS = {
              files = {
                exclude = {
                  "**/.git/**",
                  "**/node_modules/**",
                  "**/.next/**",
                  "**/dist/**",
                  "**/build/**",
                  "**/.turbo/**",
                },
              },
            },
          },
        },
        protols = {},
        nixd = {},
        postgres_lsp = {
          cmd = { "postgres-language-server", "lsp-proxy" },
          filetypes = { "sql", "psql", "pgsql", "plsql" },
          root_dir = function(...)
            local arg1 = select(1, ...)
            if type(arg1) == "number" then
              local bufnr = arg1
              local on_dir = select(2, ...)
              local name = vim.api.nvim_buf_get_name(bufnr)
              local dir = (name ~= "" and vim.fs.dirname(name)) or vim.loop.cwd()
              if type(on_dir) == "function" then
                on_dir(dir)
              end
              return dir
            end

            local fname = type(arg1) == "string" and arg1 or vim.api.nvim_buf_get_name(0)
            return (fname ~= "" and vim.fs.dirname(fname)) or vim.loop.cwd()
          end,
          workspace_required = false,
          single_file_support = true,
        },
      }

      if qml_cmd then
        servers.qmlls = {
          cmd = qml_cmd,
        }
      end

      if (not has_new_api) and lspconfig_configs and (not lspconfig_configs.postgres_lsp) then
        lspconfig_configs.postgres_lsp = {
          default_config = {
            cmd = { "postgres-language-server", "lsp-proxy" },
            filetypes = { "sql", "psql", "pgsql", "plsql" },
            root_dir = function(fname)
              return (fname ~= "" and vim.fs.dirname(fname)) or vim.loop.cwd()
            end,
            workspace_required = false,
            single_file_support = true,
          },
        }
      end

      local function setup_legacy(name, merged)
        if not lspconfig then
          return false, "lspconfig not available"
        end

        local has_server = lspconfig_configs and lspconfig_configs[name] ~= nil
        if not has_server then
          has_server = pcall(require, "lspconfig.server_configurations." .. name)
        end
        if not has_server then
          return false, "server is not available"
        end

        local ok_setup, setup_err = pcall(function()
          lspconfig[name].setup(merged)
        end)
        if not ok_setup then
          return false, tostring(setup_err):gsub("\n.*", "")
        end
        return true
      end

      local skipped = {}
      for name, cfg in pairs(servers) do
        local merged = vim.tbl_deep_extend("force", base, cfg)
        local ok, err

        if has_new_api then
          ok, err = pcall(function()
            vim.lsp.config(name, merged)
            vim.lsp.enable(name)
          end)
          if not ok then
            err = tostring(err):gsub("\n.*", "")
          end
        else
          ok, err = setup_legacy(name, merged)
        end

        if not ok then
          table.insert(skipped, ("%s (%s)"):format(name, err))
        end
      end

      if #skipped > 0 then
        vim.schedule(function()
          vim.notify("Unavailable LSP servers: " .. table.concat(skipped, ", "), vim.log.levels.WARN)
        end)
      end

      if vim.fn.exists(":LspInfo") == 0 then
        vim.api.nvim_create_user_command("LspInfo", function()
          vim.cmd("checkhealth vim.lsp")
        end, {
          desc = "Show LSP health information",
        })
      end

      lsp.enable_auto_attach()
    end,
  },
}
