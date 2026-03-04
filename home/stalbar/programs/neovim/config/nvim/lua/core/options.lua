vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
local is_neovide = vim.g.neovide

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.updatetime = 200
opt.timeoutlen = 400

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.cursorline = true
opt.numberwidth = 5
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.wrap = false
opt.laststatus = 3
opt.cmdheight = 0
opt.foldenable = false
opt.foldmethod = "manual"
opt.foldlevel = 99
opt.foldlevelstart = 99

opt.fillchars = {
  eob = " ",
  fold = " ",
  foldsep = " ",
  foldopen = "",
  foldclose = "",
  diff = "╱",
}

opt.smoothscroll = true
opt.showtabline = 0
opt.winblend = 8
opt.pumblend = 8

if is_neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font Mono:h14"
  vim.g.neovide_font_features = { "liga", "calt" }
  vim.opt.linespace = 1

  vim.g.neovide_opacity = 0.94
  vim.g.neovide_normal_opacity = 0.94
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_refresh_rate = 90
  opt.smoothscroll = true

  opt.winblend = 12
  opt.pumblend = 12
end

-- Register custom filetypes used by language servers.
vim.filetype.add({
  extension = {
    psql = "psql",
    pgsql = "pgsql",
    qmljs = "qmljs",
  },
  filename = {
    [".gitlab-ci.yml"] = "yaml.gitlab",
    [".gitlab-ci.yaml"] = "yaml.gitlab",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    [".*/docker%-compose%.ya?ml"] = "yaml.docker-compose",
    [".*/charts/.*/values.*%.ya?ml"] = "yaml.helm-values",
    [".*/helm/.*/values.*%.ya?ml"] = "yaml.helm-values",
  },
})

local indent_group = vim.api.nvim_create_augroup("StalbarIndent", { clear = true })

local function set_indent(opts)
  if opts.expandtab ~= nil then
    vim.opt_local.expandtab = opts.expandtab
  end
  if opts.tabstop ~= nil then
    vim.opt_local.tabstop = opts.tabstop
    vim.opt_local.softtabstop = opts.tabstop
  end
  if opts.shiftwidth ~= nil then
    vim.opt_local.shiftwidth = opts.shiftwidth
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = {
    "cs",
    "c",
    "cpp",
    "java",
    "python",
    "rust",
    "sql",
    "psql",
    "pgsql",
    "plsql",
  },
  callback = function()
    set_indent({
      expandtab = true,
      tabstop = 4,
      shiftwidth = 4,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "go" },
  callback = function()
    set_indent({
      expandtab = false,
      tabstop = 4,
      shiftwidth = 4,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "make" },
  callback = function()
    vim.opt_local.expandtab = false
  end,
})
