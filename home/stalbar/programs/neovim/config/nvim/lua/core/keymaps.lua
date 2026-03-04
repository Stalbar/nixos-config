local function nset(key, action, desc)
  vim.keymap.set("n", key, action, { desc = desc })
end

local function iset(key, action, desc)
  vim.keymap.set("i", key, action, { desc = desc })
end

nset("<leader>sh", "<cmd>split<CR>", "Horizontal split")
nset("<leader>sv", "<cmd>vsplit<CR>", "Vertical split")

nset("<C-h>", "<C-w>h", "Go to left window")
nset("<C-j>", "<C-w>j", "Go to down window")
nset("<C-k>", "<C-w>k", "Go to upper window")
nset("<C-l>", "<C-w>l", "Go to right window")

nset("<leader>la", "<cmd>Lazy<CR>", "Open Lazy Plugin manager")
nset("<leader>ma", "<cmd>Mason<CR>", "Open Mason")

iset("jk", "<ESC>", "Escape")
iset("kj", "<ESC>", "Escape")
nset("q:", "<nop>", "")
nset("<Left>", "<nop>")
nset("<Right>", "<nop>")
nset("<Up>", "<nop>")
nset("<Down>", "<nop>")
iset("<Left>", "<nop>")
iset("<Right>", "<nop>")
iset("<Up>", "<nop>")
iset("<Down>", "<nop>")

nset("<leader>wh", "<C-w>H", "Move current window left")
nset("<leader>wj", "<C-w>J", "Move current window down")
nset("<leader>wk", "<C-w>K", "Move current window up")
nset("<leader>wl", "<C-w>L", "Move current window right")

nset("<C-Up>", ":resize +2<CR>", "Increase window height")
nset("<C-Down>", ":resize -2<CR>", "Decrease window height")
nset("<C-Left>", ":vertical resize -2<CR>", "Decrease window width")
nset("<C-Right>", ":vertical resize +2<CR>", "Increase window width")

nset("<leader>w=", "<C-w>=", "Balance window sizes")

nset("<C-s>", "<cmd>w<CR>", "Save current file")
nset("<C-q>", "<cmd>q<CR>", "Quit")
nset("<leader>gui", "<cmd>GuessIndent<CR>", "Set indentation")
nset("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
nset("]d", vim.diagnostic.goto_next, "Next diagnostic")
nset("<leader>de", function()
  vim.diagnostic.open_float(nil, { scope = "cursor", border = "rounded" })
end, "Diagnostics at cursor")
nset("<leader>dq", vim.diagnostic.setloclist, "Diagnostics to loclist")

nset("<Esc>", "<cmd>nohlsearch<CR><ESC>", "Remove Search highlight")

if vim.g.neovide then
  local function neovide_scale(delta)
    vim.g.neovide_scale_factor = math.max(0.6, (vim.g.neovide_scale_factor or 1.0) + delta)
  end

  local modes = { "n", "i", "v", "t" }
  vim.keymap.set(modes, "<C-=>", function()
    neovide_scale(0.05)
  end, { desc = "Neovide: Increase scale" })
  vim.keymap.set(modes, "<C-+>", function()
    neovide_scale(0.05)
  end, { desc = "Neovide: Increase scale" })
  vim.keymap.set(modes, "<C-->", function()
    neovide_scale(-0.05)
  end, { desc = "Neovide: Decrease scale" })
  vim.keymap.set(modes, "<C-0>", function()
    vim.g.neovide_scale_factor = 1.0
  end, { desc = "Neovide: Reset scale" })
end
