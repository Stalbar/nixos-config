return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      local source_labels = {
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        path = "[Path]",
        buffer = "[Buf]",
      }

      luasnip.config.setup({
        history = false,
        updateevents = "TextChanged,TextChangedI",
      })

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noselect",
          keyword_length = 1,
        },
        performance = {
          debounce = 40,
          throttle = 40,
          fetching_timeout = 120,
          max_view_entries = 20,
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winblend = 8,
          }),
          documentation = cmp.config.disable,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "…",
            show_labelDetails = false,
            before = function(entry, vim_item)
              vim_item.menu = source_labels[entry.source.name] or ("[" .. entry.source.name .. "]")
              return vim_item
            end,
          }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if cmp.get_selected_entry() then
                cmp.confirm({ select = false })
              else
                cmp.abort()
                fallback()
              end
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if cmp.get_selected_entry() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.abort()
                fallback()
              end
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          {
            name = "path",
            keyword_length = 1,
            option = {
              trailing_slash = true,
              label_trailing_slash = true,
              get_cwd = function()
                return vim.fn.getcwd()
              end,
            },
          },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          {
            name = "buffer",
            keyword_length = 4,
            option = {
              get_bufnrs = function()
                local bufnr = vim.api.nvim_get_current_buf()
                if vim.api.nvim_buf_line_count(bufnr) > 10000 then
                  return {}
                end
                return { bufnr }
              end,
            },
          },
        }),
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
