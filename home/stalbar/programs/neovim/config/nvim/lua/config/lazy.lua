local source = "@lazyPath@"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
local is_headless = #vim.api.nvim_list_uis() == 0

local function copy_lazy_source(src, dst)
  local cp = vim.fn.system({ "cp", "-RL", src, dst })
  if vim.v.shell_error ~= 0 then
    vim.schedule(function()
      vim.notify("Failed to bootstrap lazy.nvim copy: " .. tostring(cp), vim.log.levels.ERROR)
    end)
    return false
  end

  return true
end

local function ensure_dir_writable(path)
  local writable = vim.fn.filewritable(path)
  if writable == 1 or writable == 2 then
    return true
  end

  vim.fn.system({ "chmod", "-R", "u+w", path })
  return vim.v.shell_error == 0
end

if not uv.fs_stat(lazypath) then
  vim.fn.mkdir(vim.fn.fnamemodify(lazypath, ":h"), "p")
  if not copy_lazy_source(source, lazypath) then
    return
  end

  if not ensure_dir_writable(lazypath) then
    vim.schedule(function()
      vim.notify("Failed to make lazy.nvim writable at " .. lazypath, vim.log.levels.ERROR)
    end)
    return
  end
elseif not ensure_dir_writable(lazypath) then
  vim.schedule(function()
    vim.notify("lazy.nvim is not writable: " .. lazypath, vim.log.levels.ERROR)
  end)
  return
end

vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  vim.schedule(function()
    vim.notify("lazy.nvim is not available on runtimepath", vim.log.levels.ERROR)
  end)
  return
end

lazy.setup({
  spec = {
    { import = "plugins" },
  },
  lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json",
  defaults = {
    lazy = true,
  },
  install = {
    -- Avoid massive bootstrap/install in headless checks (can explode RAM on network failures).
    missing = not is_headless,
    colorscheme = { "nord" },
  },
  checker = {
    enabled = false,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
