local M = {}

function M.capabilities()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return capabilities
end

local function with_telescope_or(fallback, picker)
  return function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if ok and type(builtin[picker]) == "function" then
      builtin[picker]()
      return
    end
    fallback()
  end
end

function M.on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  if client.name == "ts_ls" and client.server_capabilities.semanticTokensProvider then
    client.server_capabilities.semanticTokensProvider = nil
  end

  M.apply_buffer_keymaps(bufnr)
end

local function run_code_action_for_buf(bufnr)
  local has_roslyn = false
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.name == "roslyn" then
      has_roslyn = true
      break
    end
  end

  -- Roslyn sends nested/special code actions that work better with native picker.
  if has_roslyn then
    vim.lsp.buf.code_action()
    return
  end

  local ok, preview = pcall(require, "actions-preview")
  if ok then
    preview.code_actions()
    return
  end
  vim.lsp.buf.code_action()
end

function M.apply_buffer_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      silent = true,
      desc = desc,
    })
  end

  map("n", "<leader>gd", with_telescope_or(vim.lsp.buf.definition, "lsp_definitions"), "Go to definition")
  map("n", "<leader>gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "<leader>gi", with_telescope_or(vim.lsp.buf.implementation, "lsp_implementations"), "Go to implementation")
  map("n", "<leader>gr", with_telescope_or(vim.lsp.buf.references, "lsp_references"), "Go to references")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map({ "n", "v" }, "<leader>ca", function()
    run_code_action_for_buf(bufnr)
  end, "Code action")
  map("n", "ga", function()
    run_code_action_for_buf(bufnr)
  end, "Code action")
  map("n", "K", vim.lsp.buf.hover, "Hover")
end

function M.enable_auto_attach()
  local grp = vim.api.nvim_create_augroup("UserLspAutoAttach", { clear = true })
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = grp,
    callback = function(args)
      local bufnr = args.buf
      if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "" then
        return
      end
      if #vim.lsp.get_clients({ bufnr = bufnr }) > 0 then
        return
      end
      vim.schedule(function()
        pcall(vim.cmd, "silent! LspStart")
      end)
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = grp,
    callback = function(args)
      M.apply_buffer_keymaps(args.buf)
    end,
  })
end

return M
