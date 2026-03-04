return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      local logo = {
        "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "",
        "     󱄅  stalbar  •  nixos  •  hyprland  •  neovide",
      }
      dashboard.section.header.val = logo

      local function apply_alpha_colors()
        local set = vim.api.nvim_set_hl
        local grad = {
          "#bf616a",
          "#d08770",
          "#ebcb8b",
          "#a3be8c",
          "#8fbcbb",
          "#88c0d0",
          "#81a1c1",
        }

        for i, c in ipairs(grad) do
          set(0, "AlphaLogo" .. i, { fg = c, bg = "NONE", bold = true })
        end

        set(0, "AlphaBadge", { fg = "#eceff4", bg = "NONE", bold = true })
        set(0, "AlphaButtons", { fg = "#d8dee9", bg = "NONE" })
        set(0, "AlphaShortcut", { fg = "#88c0d0", bg = "NONE", bold = true })
        set(0, "AlphaFooter", { fg = "#4c566a", bg = "NONE" })
      end

      apply_alpha_colors()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("UserAlphaNordColors", { clear = true }),
        callback = function()
          pcall(apply_alpha_colors)
        end,
      })

      dashboard.section.header.opts.hl = {
        { { "AlphaLogo1", 0, -1 } },
        { { "AlphaLogo2", 0, -1 } },
        { { "AlphaLogo3", 0, -1 } },
        { { "AlphaLogo4", 0, -1 } },
        { { "AlphaLogo5", 0, -1 } },
        { { "AlphaLogo6", 0, -1 } },
        { { "AlphaLogo7", 0, -1 } },
        { { "AlphaBadge", 0, -1 } },
      }

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", "<cmd>ene<CR>"),
        dashboard.button("f", "󰱼  Explorer", "<cmd>Neotree toggle left<CR>"),
        dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
        dashboard.button("n", "󱐋  Noice", "<cmd>Noice<CR>"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
      }

      for _, b in ipairs(dashboard.section.buttons.val) do
        b.opts.hl = "AlphaButtons"
        b.opts.hl_shortcut = "AlphaShortcut"
      end

      local function footer()
        local v = vim.version()
        local ver = ("v%d.%d.%d"):format(v.major, v.minor, v.patch)

        local ok, lazy = pcall(require, "lazy")
        if ok then
          local st = lazy.stats()
          local ms = (math.floor(st.startuptime * 100 + 0.5) / 100)
          return ("⚡ %s  •  %d/%d plugins  •  %sms"):format(ver, st.loaded, st.count, ms)
        end

        return ("⚡ %s"):format(ver)
      end

      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.opts.layout = {
        { type = "padding", val = 4 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }
      dashboard.opts.opts.noautocmd = true

      alpha.setup(dashboard.opts)
    end,
  },
}
