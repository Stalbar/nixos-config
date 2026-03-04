local M = {}

local group = vim.api.nvim_create_augroup("stalbar_autosave", { clear = true })

local function can_save(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end
  if not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
    return false
  end
  if not vim.bo[bufnr].modified then
    return false
  end
  if vim.api.nvim_buf_get_name(bufnr) == "" then
    return false
  end
  return true
end

local function save_buf(bufnr)
  if not can_save(bufnr) then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    pcall(vim.cmd, "silent! update")
  end)
end

function M.setup()
  vim.api.nvim_create_autocmd("FocusLost", {
    group = group,
    desc = "Auto-save all changed buffers when Neovim loses focus",
    callback = function()
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        save_buf(bufnr)
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    desc = "Auto-save changed buffer on focus change",
    callback = function(args)
      save_buf(args.buf)
    end,
  })
end

return M
