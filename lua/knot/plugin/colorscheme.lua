return {
	{
		"CWood-sdf/pineapple",
		dependencies = require("knot.pineapple"),
		opts = {
			installedRegistry = "knot.pineapple",
			colorschemeFile = "after/plugin/theme.lua",
		},
		cmd = "Pineapple",
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			flavour = "mocha", -- latte, frappe, macchiato, mocha
	--
	-- 			background = {
	-- 				light = "latte",
	-- 				dark = "mocha",
	-- 			},
	-- 			transparent_background = false,
	-- 			show_end_of_buffer = true,
	-- 			term_colors = true,
	-- 			styles = {
	-- 				comments = { "italic" },
	-- 				conditionals = { "italic" },
	-- 				loops = {},
	-- 				functions = {},
	-- 				keywords = {},
	-- 				strings = {},
	-- 				variables = {},
	-- 				numbers = {},
	-- 				booleans = {},
	-- 				properties = {},
	-- 				types = {},
	-- 				operators = {},
	-- 			},
	-- 		})
	-- 		vim.cmd("colorscheme catppuccin")
	-- 	end,
	-- },
}
