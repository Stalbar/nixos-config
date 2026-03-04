local M = {}

local icons = {
  [vim.diagnostic.severity.ERROR] = "",
  [vim.diagnostic.severity.WARN] = "",
  [vim.diagnostic.severity.INFO] = "",
  [vim.diagnostic.severity.HINT] = "󰌵",
}

function M.setup()
  vim.fn.sign_define("DiagnosticSignError", {
    text = icons[vim.diagnostic.severity.ERROR] .. " ",
    texthl = "DiagnosticSignError",
    numhl = "",
  })
  vim.fn.sign_define("DiagnosticSignWarn", {
    text = icons[vim.diagnostic.severity.WARN] .. " ",
    texthl = "DiagnosticSignWarn",
    numhl = "",
  })
  vim.fn.sign_define("DiagnosticSignInfo", {
    text = icons[vim.diagnostic.severity.INFO] .. " ",
    texthl = "DiagnosticSignInfo",
    numhl = "",
  })
  vim.fn.sign_define("DiagnosticSignHint", {
    text = icons[vim.diagnostic.severity.HINT] .. " ",
    texthl = "DiagnosticSignHint",
    numhl = "",
  })

  vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    signs = true,
    virtual_text = {
      spacing = 2,
      source = "if_many",
      prefix = function(diagnostic)
        return (icons[diagnostic.severity] or "●") .. " "
      end,
      format = function(diagnostic)
        local msg = diagnostic.message or ""
        return tostring(msg):gsub("%s+", " ")
      end,
    },
    float = {
      border = "rounded",
      source = "if_many",
      header = "",
    },
  })

  local group = vim.api.nvim_create_augroup("UserDiagnosticsFloat", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    group = group,
    callback = function()
      if vim.fn.mode() ~= "n" then
        return
      end
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      local current = vim.diagnostic.get(0, { lnum = lnum })
      if not current or vim.tbl_isempty(current) then
        return
      end

      pcall(vim.diagnostic.open_float, nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "if_many",
        scope = "cursor",
        header = "",
      })
    end,
  })
end

return M
