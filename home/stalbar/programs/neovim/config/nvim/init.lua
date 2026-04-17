do
	if vim.g.neovide then
		vim.loader.enable(false)
	else
		vim.loader.enable()
	end
end

require("core.options")
require("core.keymaps")
require("core.autosave").setup()
require("core.diagnostics").setup()
require("config.lazy")

local theme = require("config.theme")
theme.apply()
theme.setup_watcher()
