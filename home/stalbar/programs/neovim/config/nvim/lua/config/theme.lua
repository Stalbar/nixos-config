local M = {}

function M.current()
	return {
		name = "tokyonight",
		mode = "dark",
		colorscheme = "tokyonight",
		colors = {
			bg0 = "#1a1b26",
			bg1 = "#24283b",
			bg3 = "#414868",
			fg0 = "#c0caf5",
			fg1 = "#a9b1d6",
			muted = "#565f89",
			info = "#7dcfff",
			accent = "#7aa2f7",
			accent2 = "#bb9af7",
			accent3 = "#9ece6a",
			success = "#9ece6a",
			warning = "#e0af68",
			error = "#f7768e",
			orange = "#ff9e64",
			purple = "#bb9af7",
		},
	}
end

function M.apply()
	local ok, tokyonight = pcall(require, "tokyonight")
	if ok then
		tokyonight.setup({ style = "night", transparent = false })
	end
	pcall(vim.cmd.colorscheme, "tokyonight")
end

function M.setup_watcher() end

return M
