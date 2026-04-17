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
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      local ok_npairs, npairs = pcall(require, "nvim-autopairs")
      local enter_confirms_selection = false

      local function feed(keys)
        local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
        vim.api.nvim_feedkeys(termcodes, "i", true)
      end

      local function feed_raw(keys)
        vim.api.nvim_feedkeys(keys, "n", true)
      end

      local function trigger_autopairs_cr()
        if not ok_npairs then
          return false
        end

        vim.schedule(function()
          feed_raw(npairs.autopairs_cr())
        end)
        return true
      end

      local function confirm_entry()
        cmp.confirm({
          select = false,
          behavior = cmp.ConfirmBehavior.Replace,
        })
      end

      local function confirm_and_feed(char)
        return cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_selected_entry() then
            confirm_entry()
            vim.schedule(function()
              feed(char)
            end)
            return
          end

          fallback()
        end, { "i" })
      end

      local function newline_or_autopairs()
        return cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.abort()
          end

          if trigger_autopairs_cr() then
            return
          end

          fallback()
        end, { "i", "s" })
      end

      local function confirm_selected_or_newline()
        return cmp.mapping(function(fallback)
          if cmp.visible() and enter_confirms_selection and cmp.get_selected_entry() then
            enter_confirms_selection = false
            confirm_entry()
            return
          end

          enter_confirms_selection = false

          if cmp.visible() then
            cmp.abort()
          end

          if trigger_autopairs_cr() then
            return
          end

          fallback()
        end, { "i", "s" })
      end

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
          ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              enter_confirms_selection = true
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.choice_active() then
              luasnip.change_choice(1)
            else
              fallback()
            end
          end, { "i", "c" }),
          ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              enter_confirms_selection = true
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.choice_active() then
              luasnip.change_choice(-1)
            else
              fallback()
            end
          end, { "i", "c" }),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              enter_confirms_selection = false
              confirm_entry()
              return
            end

            if luasnip.jumpable(1) then
              luasnip.jump(1)
              return
            end

            if cmp.visible() then
              enter_confirms_selection = false
              cmp.abort()
            end

            if trigger_autopairs_cr() then
              return
            end

            fallback()
          end, { "i", "s" }),
          ["<Space>"] = confirm_and_feed(" "),
          ["."] = confirm_and_feed("."),
          [","] = confirm_and_feed(","),
          [";"] = confirm_and_feed(";"),
          [":"] = confirm_and_feed(":"),
          ["("] = confirm_and_feed("("),
          [")"] = confirm_and_feed(")"),
          ["<Tab>"] = cmp.mapping(function(fallback)
            fallback()
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            fallback()
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

      cmp.setup.filetype({ "cs" }, {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
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
        }),
      })

      cmp.setup.filetype({ "javascriptreact", "typescriptreact", "html", "css", "scss", "sass" }, {
        completion = {
          keyword_length = 3,
        },
        performance = {
          debounce = 120,
          throttle = 160,
          fetching_timeout = 250,
          max_view_entries = 12,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp", keyword_length = 3, max_item_count = 8 },
          { name = "luasnip" },
          {
            name = "path",
            keyword_length = 2,
            option = {
              trailing_slash = true,
              label_trailing_slash = true,
              get_cwd = function()
                return vim.fn.getcwd()
              end,
            },
          },
        }),
      })

      cmp.setup.filetype({ "go", "gomod", "gowork" }, {
        mapping = {
          ["<CR>"] = confirm_selected_or_newline(),
        },
      })

    end,
  },
}
