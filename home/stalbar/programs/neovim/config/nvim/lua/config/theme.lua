local M = {}
local registry_dir = vim.fn.expand("~/.local/state/stalbar-theme/nvim-servers")

local function with_background(background, fn)
	return function()
		vim.o.background = background
		if fn then
			fn()
		end
	end
end

local function catppuccin_theme(name, flavour, colors)
	return {
		name = name,
		mode = flavour == "latte" and "light" or "dark",
		colorscheme = "catppuccin-" .. flavour,
		colors = colors,
		setup = with_background(flavour == "latte" and "light" or "dark", function()
			local ok, catppuccin = pcall(require, "catppuccin")
			if ok then
				catppuccin.setup({
					flavour = flavour,
					integrations = {
						notify = true,
						which_key = true,
					},
				})
			end
		end),
	}
end

local function rose_pine_theme(name, variant, colors)
	return {
		name = name,
		mode = variant == "dawn" and "light" or "dark",
		colorscheme = "rose-pine-" .. variant,
		colors = colors,
		setup = with_background(variant == "dawn" and "light" or "dark", function()
			local ok, rose_pine = pcall(require, "rose-pine")
			if ok then
				rose_pine.setup({
					variant = variant,
					dark_variant = "main",
					styles = {
						italic = true,
						transparency = false,
					},
				})
			end
		end),
	}
end

local function everforest_theme(name, background, mode, colors)
	return {
		name = name,
		mode = mode,
		colorscheme = "everforest",
		colors = colors,
		setup = with_background(mode, function()
			vim.g.everforest_background = background
			vim.g.everforest_enable_italic = 1
			vim.g.everforest_better_performance = 1
		end),
	}
end

local function solarized_theme(name, variant, mode, colors)
	return {
		name = name,
		mode = mode,
		colorscheme = "solarized",
		colors = colors,
		setup = with_background(mode, function()
			local ok, solarized = pcall(require, "solarized")
			if ok then
				solarized.setup({
					variant = variant,
					styles = {
						comments = { italic = true },
					},
				})
			end
		end),
	}
end

local theme_map = {
	nord = {
		name = "nord",
		mode = "dark",
		colorscheme = "nord",
		colors = {
			bg0 = "#2E3440",
			bg1 = "#3B4252",
			bg3 = "#4C566A",
			fg0 = "#ECEFF4",
			fg1 = "#D8DEE9",
			muted = "#4C566A",
			info = "#8FBCBB",
			accent = "#88C0D0",
			accent2 = "#5E81AC",
			accent3 = "#81A1C1",
			success = "#A3BE8C",
			warning = "#EBCB8B",
			error = "#BF616A",
			orange = "#D08770",
			purple = "#B48EAD",
		},
		setup = with_background("dark", function()
			vim.g.nord_contrast = true
			vim.g.nord_borders = false
			vim.g.nord_disable_background = false
			vim.g.nord_italic = true
			vim.g.nord_uniform_status_lines = true
			vim.g.nord_cursor_line_number_background = false
		end),
	},
	gruvbox = {
		name = "gruvbox",
		mode = "dark",
		colorscheme = "gruvbox-material",
		colors = {
			bg0 = "#282828",
			bg1 = "#32302F",
			bg3 = "#504945",
			fg0 = "#DDC7A1",
			fg1 = "#D4BE98",
			muted = "#7C6F64",
			info = "#89B482",
			accent = "#7DAEA3",
			accent2 = "#7DAEA3",
			accent3 = "#A9B665",
			success = "#A9B665",
			warning = "#D8A657",
			error = "#EA6962",
			orange = "#E78A4E",
			purple = "#D3869B",
		},
		setup = with_background("dark", function()
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_better_performance = 1
		end),
	},
	["catppuccin-mocha"] = catppuccin_theme("catppuccin-mocha", "mocha", {
		bg0 = "#1E1E2E",
		bg1 = "#181825",
		bg3 = "#45475A",
		fg0 = "#F5E0DC",
		fg1 = "#CDD6F4",
		muted = "#6C7086",
		info = "#94E2D5",
		accent = "#74C7EC",
		accent2 = "#89B4FA",
		accent3 = "#B4BEFE",
		success = "#A6E3A1",
		warning = "#F9E2AF",
		error = "#F38BA8",
		orange = "#FAB387",
		purple = "#CBA6F7",
	}),
	["catppuccin-latte"] = catppuccin_theme("catppuccin-latte", "latte", {
		bg0 = "#EFF1F5",
		bg1 = "#E6E9EF",
		bg3 = "#BCC0CC",
		fg0 = "#313244",
		fg1 = "#45475A",
		muted = "#7C7F93",
		info = "#179299",
		accent = "#04A5E5",
		accent2 = "#1E66F5",
		accent3 = "#8839EF",
		success = "#40A02B",
		warning = "#DF8E1D",
		error = "#D20F39",
		orange = "#FE640B",
		purple = "#8839EF",
	}),
	kanagawa = {
		name = "kanagawa",
		mode = "dark",
		colorscheme = "kanagawa",
		colors = {
			bg0 = "#1F1F28",
			bg1 = "#16161D",
			bg3 = "#2A2A37",
			fg0 = "#DCD7BA",
			fg1 = "#DCD7BA",
			muted = "#727169",
			info = "#7FB4CA",
			accent = "#6A9589",
			accent2 = "#7E9CD8",
			accent3 = "#658594",
			success = "#98BB6C",
			warning = "#E6C384",
			error = "#E46876",
			orange = "#FF9E3B",
			purple = "#957FB8",
		},
		setup = with_background("dark", function()
			local ok, kanagawa = pcall(require, "kanagawa")
			if ok then
				kanagawa.setup({
					theme = "wave",
					transparent = false,
					commentStyle = { italic = true },
				})
			end
		end),
	},
	["rose-pine"] = {
		name = "rose-pine",
		mode = "dark",
		colorscheme = "rose-pine",
		colors = {
			bg0 = "#191724",
			bg1 = "#1F1D2E",
			bg3 = "#393552",
			fg0 = "#F6F3FF",
			fg1 = "#E0DEF4",
			muted = "#6E6A86",
			info = "#9CCFD8",
			accent = "#31748F",
			accent2 = "#C4A7E7",
			accent3 = "#9CCFD8",
			success = "#9CCFD8",
			warning = "#F6C177",
			error = "#EB6F92",
			orange = "#EA9A97",
			purple = "#C4A7E7",
		},
		setup = with_background("dark", function()
			local ok, rose_pine = pcall(require, "rose-pine")
			if ok then
				rose_pine.setup({
					variant = "main",
					dark_variant = "main",
					styles = {
						italic = true,
						transparency = false,
					},
				})
			end
		end),
	},
	["rose-pine-dawn"] = rose_pine_theme("rose-pine-dawn", "dawn", {
		bg0 = "#FAF4ED",
		bg1 = "#FFF8F0",
		bg3 = "#DFDAD9",
		fg0 = "#433C67",
		fg1 = "#575279",
		muted = "#86819A",
		info = "#286983",
		accent = "#56949F",
		accent2 = "#7E6A94",
		accent3 = "#D7827E",
		success = "#56949F",
		warning = "#EA9D34",
		error = "#B4637A",
		orange = "#D7827E",
		purple = "#907AA9",
	}),
	onedark = {
		name = "onedark",
		mode = "dark",
		colorscheme = "onedark",
		colors = {
			bg0 = "#282C34",
			bg1 = "#21252B",
			bg3 = "#3E4452",
			fg0 = "#E6EAF2",
			fg1 = "#ABB2BF",
			muted = "#4B5263",
			info = "#56B6C2",
			accent = "#61AFEF",
			accent2 = "#528BFF",
			accent3 = "#98C379",
			success = "#98C379",
			warning = "#E5C07B",
			error = "#E06C75",
			orange = "#D19A66",
			purple = "#C678DD",
		},
		setup = with_background("dark", function()
			local ok, onedark = pcall(require, "onedark")
			if ok then
				onedark.setup({ style = "dark" })
			end
		end),
	},
	everforest = everforest_theme("everforest", "hard", "dark", {
		bg0 = "#2D353B",
		bg1 = "#343F44",
		bg3 = "#475258",
		fg0 = "#E4E1CD",
		fg1 = "#D3C6AA",
		muted = "#859289",
		info = "#7FBBB3",
		accent = "#83C092",
		accent2 = "#7FBBB3",
		accent3 = "#A7C080",
		success = "#A7C080",
		warning = "#DBBC7F",
		error = "#E67E80",
		orange = "#E69875",
		purple = "#D699B6",
	}),
	["everforest-light"] = everforest_theme("everforest-light", "soft", "light", {
		bg0 = "#FDF6E3",
		bg1 = "#F4EFD8",
		bg3 = "#D3C6AA",
		fg0 = "#475258",
		fg1 = "#56635F",
		muted = "#788680",
		info = "#3A94C5",
		accent = "#35A77C",
		accent2 = "#4C6A92",
		accent3 = "#8DA101",
		success = "#8DA101",
		warning = "#DFA000",
		error = "#F85552",
		orange = "#F57D26",
		purple = "#DF69BA",
	}),
	cyberdream = {
		name = "cyberdream",
		mode = "dark",
		colorscheme = "cyberdream",
		colors = {
			bg0 = "#16181A",
			bg1 = "#1E2124",
			bg3 = "#2D3136",
			fg0 = "#FFFFFF",
			fg1 = "#D7D7D7",
			muted = "#5B6065",
			info = "#5EF1FF",
			accent = "#5EEAD4",
			accent2 = "#5EA1FF",
			accent3 = "#BD5EFF",
			success = "#5EFF6C",
			warning = "#FFF38C",
			error = "#FF6E5E",
			orange = "#FFBD5E",
			purple = "#BD5EFF",
		},
		setup = with_background("dark", function()
			local ok, cyberdream = pcall(require, "cyberdream")
			if ok then
				cyberdream.setup({
					transparent = false,
					italic_comments = true,
				})
			end
		end),
	},
	dracula = {
		name = "dracula",
		mode = "dark",
		colorscheme = "dracula",
		colors = {
			bg0 = "#282A36",
			bg1 = "#343746",
			bg3 = "#6272A4",
			fg0 = "#F8F8F2",
			fg1 = "#F8F8F2",
			muted = "#6272A4",
			info = "#8BE9FD",
			accent = "#8BE9FD",
			accent2 = "#BD93F9",
			accent3 = "#FF79C6",
			success = "#50FA7B",
			warning = "#F1FA8C",
			error = "#FF5555",
			orange = "#FFB86C",
			purple = "#FF79C6",
		},
		setup = with_background("dark", function()
			local ok, dracula = pcall(require, "dracula")
			if ok then
				dracula.setup({
					show_end_of_buffer = true,
					italic_comment = true,
				})
			end
		end),
	},
	solarized = solarized_theme("solarized", "winter", "dark", {
		bg0 = "#002B36",
		bg1 = "#073642",
		bg3 = "#586E75",
		fg0 = "#FDF6E3",
		fg1 = "#93A1A1",
		muted = "#657B83",
		info = "#2AA198",
		accent = "#2AA198",
		accent2 = "#268BD2",
		accent3 = "#859900",
		success = "#859900",
		warning = "#B58900",
		error = "#DC322F",
		orange = "#CB4B16",
		purple = "#6C71C4",
	}),
	["solarized-light"] = solarized_theme("solarized-light", "summer", "light", {
		bg0 = "#FDF6E3",
		bg1 = "#EEE8D5",
		bg3 = "#93A1A1",
		fg0 = "#073642",
		fg1 = "#465A61",
		muted = "#657B83",
		info = "#2AA198",
		accent = "#268BD2",
		accent2 = "#6C71C4",
		accent3 = "#859900",
		success = "#859900",
		warning = "#B58900",
		error = "#DC322F",
		orange = "#CB4B16",
		purple = "#6C71C4",
	}),
	osaka = {
		name = "osaka",
		mode = "dark",
		colorscheme = "solarized-osaka",
		colors = {
			bg0 = "#16161D",
			bg1 = "#1F2335",
			bg3 = "#414868",
			fg0 = "#C0CAF5",
			fg1 = "#A9B1D6",
			muted = "#565F89",
			info = "#7DCFFF",
			accent = "#73DACA",
			accent2 = "#7AA2F7",
			accent3 = "#BB9AF7",
			success = "#9ECE6A",
			warning = "#E0AF68",
			error = "#F7768E",
			orange = "#FF9E64",
			purple = "#BB9AF7",
		},
		setup = with_background("dark", function()
			local ok, osaka = pcall(require, "solarized-osaka")
			if ok then
				osaka.setup({
					transparent = false,
					styles = {
						comments = { italic = true },
					},
				})
			end
		end),
	},
	sonokai = {
		name = "sonokai",
		mode = "dark",
		colorscheme = "sonokai",
		colors = {
			bg0 = "#2C2E34",
			bg1 = "#33353F",
			bg3 = "#414550",
			fg0 = "#E2E2E3",
			fg1 = "#E2E2E3",
			muted = "#7F8490",
			info = "#76CCE0",
			accent = "#7DCFFF",
			accent2 = "#B39DF3",
			accent3 = "#9ED072",
			success = "#9ED072",
			warning = "#E7C664",
			error = "#FC5D7C",
			orange = "#F39660",
			purple = "#B39DF3",
		},
		setup = with_background("dark", function()
			vim.g.sonokai_style = "default"
			vim.g.sonokai_enable_italic = 1
			vim.g.sonokai_better_performance = 1
		end),
	},
	tokyodark = {
		name = "tokyodark",
		mode = "dark",
		colorscheme = "tokyodark",
		colors = {
			bg0 = "#11121D",
			bg1 = "#1B1C2B",
			bg3 = "#2C2D3C",
			fg0 = "#C0CAF5",
			fg1 = "#A0A8CD",
			muted = "#565F89",
			info = "#2AC3DE",
			accent = "#7DCFFF",
			accent2 = "#7199EE",
			accent3 = "#9ECE6A",
			success = "#9ECE6A",
			warning = "#E0AF68",
			error = "#F7768E",
			orange = "#FF9E64",
			purple = "#BB9AF7",
		},
		setup = with_background("dark", function()
			local ok, tokyodark = pcall(require, "tokyodark")
			if ok then
				tokyodark.setup({
					transparent_background = false,
				})
			end
		end),
	},
	fluoromachine = {
		name = "fluoromachine",
		mode = "dark",
		colorscheme = "fluoromachine",
		colors = {
			bg0 = "#1A1B26",
			bg1 = "#23283D",
			bg3 = "#4A4F74",
			fg0 = "#FFF9F2",
			fg1 = "#D5D7E3",
			muted = "#646B8C",
			info = "#6AE4FC",
			accent = "#00DFFF",
			accent2 = "#4D78FF",
			accent3 = "#95FFDA",
			success = "#95FFA4",
			warning = "#FFF272",
			error = "#FF7AA2",
			orange = "#FFB86C",
			purple = "#D5A6FF",
		},
		setup = with_background("dark", function()
			local ok, fluoromachine = pcall(require, "fluoromachine")
			if ok then
				fluoromachine.setup({
					glow = false,
					transparent = false,
				})
			end
		end),
	},
	moonlight = {
		name = "moonlight",
		mode = "dark",
		colorscheme = "moonlight",
		colors = {
			bg0 = "#212337",
			bg1 = "#2A2E45",
			bg3 = "#4A4F73",
			fg0 = "#E6E9FF",
			fg1 = "#C8D3F5",
			muted = "#7480B3",
			info = "#86E1FC",
			accent = "#65BCFF",
			accent2 = "#82AAFF",
			accent3 = "#FCA7EA",
			success = "#C3E88D",
			warning = "#FFC777",
			error = "#FF757F",
			orange = "#FF966C",
			purple = "#FCA7EA",
		},
		setup = with_background("dark"),
	},
	["highcontrast-dark"] = {
		name = "highcontrast-dark",
		mode = "dark",
		colorscheme = "habamax",
		colors = {
			bg0 = "#000000",
			bg1 = "#111111",
			bg3 = "#FFFFFF",
			fg0 = "#FFFFFF",
			fg1 = "#F2F2F2",
			muted = "#A0A0A0",
			info = "#00FFFF",
			accent = "#00BFFF",
			accent2 = "#FFD700",
			accent3 = "#7CFC00",
			success = "#7CFC00",
			warning = "#FFD700",
			error = "#FF4D4D",
			orange = "#FF8C00",
			purple = "#DA70D6",
		},
		setup = with_background("dark"),
	},
	["highcontrast-light"] = {
		name = "highcontrast-light",
		mode = "light",
		colorscheme = "morning",
		colors = {
			bg0 = "#FFFFFF",
			bg1 = "#F2F2F2",
			bg3 = "#000000",
			fg0 = "#000000",
			fg1 = "#111111",
			muted = "#666666",
			info = "#005FCC",
			accent = "#0066FF",
			accent2 = "#7A00CC",
			accent3 = "#008A00",
			success = "#008A00",
			warning = "#A05A00",
			error = "#CC0000",
			orange = "#CC5500",
			purple = "#7A00CC",
		},
		setup = with_background("light"),
	},
}

local function set_highlights(colors)
	local set = vim.api.nvim_set_hl

	set(0, "NormalFloat", { bg = colors.bg1 })
	set(0, "FloatBorder", { fg = colors.bg3, bg = colors.bg1 })
	set(0, "Pmenu", { bg = colors.bg1 })
	set(0, "PmenuSel", { fg = colors.fg0, bg = colors.accent2, bold = true })

	set(0, "Comment", { fg = colors.accent3, italic = true })
	set(0, "@comment", { link = "Comment" })
	set(0, "@comment.documentation", { fg = colors.info, italic = true })

	set(0, "String", { fg = colors.success })
	set(0, "@string", { link = "String" })
	set(0, "Character", { fg = colors.warning })
	set(0, "@character", { link = "Character" })
	set(0, "Delimiter", { fg = colors.accent })
	set(0, "@punctuation.delimiter", { link = "Delimiter" })

	set(0, "@tag", { fg = colors.accent, bold = true })
	set(0, "@tag.attribute", { fg = colors.warning, italic = true })
	set(0, "@tag.delimiter", { fg = colors.muted })
	set(0, "@tag.builtin", { fg = colors.info, bold = true })

	set(0, "RainbowDelimiterBlue", { fg = colors.accent2 })
	set(0, "RainbowDelimiterCyan", { fg = colors.info })
	set(0, "RainbowDelimiterGreen", { fg = colors.success })
	set(0, "RainbowDelimiterYellow", { fg = colors.warning })
	set(0, "RainbowDelimiterOrange", { fg = colors.orange })
	set(0, "RainbowDelimiterRed", { fg = colors.error })
	set(0, "RainbowDelimiterViolet", { fg = colors.purple })
end

local function build_lualine_theme(colors)
	return {
		normal = {
			a = { bg = colors.accent2, fg = colors.fg0, gui = "bold" },
			b = { bg = colors.bg1, fg = colors.fg1 },
			c = { bg = colors.bg0, fg = colors.fg1 },
		},
		insert = {
			a = { bg = colors.success, fg = colors.bg0, gui = "bold" },
			b = { bg = colors.bg1, fg = colors.fg1 },
			c = { bg = colors.bg0, fg = colors.fg1 },
		},
		visual = {
			a = { bg = colors.purple, fg = colors.bg0, gui = "bold" },
			b = { bg = colors.bg1, fg = colors.fg1 },
			c = { bg = colors.bg0, fg = colors.fg1 },
		},
		replace = {
			a = { bg = colors.orange, fg = colors.bg0, gui = "bold" },
			b = { bg = colors.bg1, fg = colors.fg1 },
			c = { bg = colors.bg0, fg = colors.fg1 },
		},
		command = {
			a = { bg = colors.warning, fg = colors.bg0, gui = "bold" },
			b = { bg = colors.bg1, fg = colors.fg1 },
			c = { bg = colors.bg0, fg = colors.fg1 },
		},
		inactive = {
			a = { bg = colors.bg0, fg = colors.muted, gui = "bold" },
			b = { bg = colors.bg0, fg = colors.muted },
			c = { bg = colors.bg0, fg = colors.muted },
		},
	}
end

local function read_theme_name()
	local state_file = vim.fn.expand("~/.config/stalbar-theme/current")
	local ok, lines = pcall(vim.fn.readfile, state_file)
	if not ok or not lines or not lines[1] then
		return "nord"
	end

	local theme = vim.trim(lines[1])
	if theme_map[theme] then
		return theme
	end

	return "nord"
end

local function ensure_server()
	if vim.v.servername ~= nil and vim.v.servername ~= "" then
		return vim.v.servername
	end

	local run_dir = vim.fn.stdpath("run")
	local address = run_dir .. "/theme-" .. vim.fn.getpid() .. ".sock"
	local ok = pcall(vim.fn.serverstart, address)
	if ok and vim.v.servername ~= nil and vim.v.servername ~= "" then
		return vim.v.servername
	end

	return nil
end

local function register_server()
	local server = ensure_server()
	if not server or server == "" then
		return
	end

	vim.fn.mkdir(registry_dir, "p")

	local entry = registry_dir .. "/" .. tostring(vim.fn.getpid())
	pcall(vim.fn.writefile, { server }, entry)

	vim.api.nvim_create_autocmd("VimLeavePre", {
		once = true,
		callback = function()
			pcall(vim.fn.delete, entry)
		end,
	})
end

function M.current()
	return theme_map[read_theme_name()]
end

function M.apply(theme_name)
	local theme = theme_map[theme_name or read_theme_name()] or theme_map.nord
	local mode = theme.mode or "dark"

	if theme.setup then
		pcall(theme.setup)
	end

	local ok = pcall(vim.cmd.colorscheme, theme.colorscheme)
	if not ok and theme.colorscheme ~= "nord" then
		theme = theme_map.nord
		if theme.setup then
			pcall(theme.setup)
		end
		pcall(vim.cmd.colorscheme, theme.colorscheme)
	end

	set_highlights(theme.colors)

	if vim.g.neovide then
		local light = mode == "light"
		vim.g.neovide_opacity = light and 1.0 or 0.96
		vim.g.neovide_normal_opacity = vim.g.neovide_opacity
		vim.opt.winblend = light and 0 or 12
		vim.opt.pumblend = light and 0 or 12
	end

	local ok_lualine, lualine = pcall(require, "lualine")
	if ok_lualine and lualine.get_config then
		local cfg = lualine.get_config()
		cfg.options.theme = build_lualine_theme(theme.colors)
		lualine.setup(cfg)
	end
end

function M.setup_watcher()
	if M._watcher_started then
		return
	end

	register_server()

	local uv = vim.uv or vim.loop
	local state_file = vim.fn.expand("~/.config/stalbar-theme/current")
	local state_dir = vim.fn.fnamemodify(state_file, ":h")
	local state_name = vim.fn.fnamemodify(state_file, ":t")
	local watcher = uv.new_fs_event()
	if not watcher then
		return
	end

	watcher:start(
		state_dir,
		{},
		vim.schedule_wrap(function(err, filename)
			if err or filename ~= state_name then
				return
			end

			vim.defer_fn(function()
				pcall(M.apply)
			end, 50)
		end)
	)

	M._watcher = watcher
	M._watcher_started = true
end

return M
