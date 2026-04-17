return {
	{
		"nickjvandyke/opencode.nvim",
		version = "*",
		init = function()
			vim.o.autoread = true
		end,
		keys = {
			{
				"<C-.>",
				mode = { "n", "t" },
				function()
					require("opencode").toggle()
				end,
				desc = "Toggle opencode",
			},
		},
		config = function()
			vim.g.opencode_opts = {}
		end,
	},
}
