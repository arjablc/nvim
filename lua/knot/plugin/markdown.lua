local notes_vault = vim.fs.normalize(vim.fn.expand("~") .. "/Documents/notes_vault")

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
		opts = {
			code = {
				enabled = true,
				sign = true,
				style = "full",
				width = "block",
				left_pad = 0,
				right_pad = 0,
			},
		},
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		lazy = true,
		event = {
			"BufReadPre " .. notes_vault .. "/**/*.md",
			"BufNewFile " .. notes_vault .. "/**/*.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					name = "notes_vault",
					path = notes_vault,
				},
			},
			new_notes_location = "current_dir",
			open_notes_in = "vsplit",
			note_id_func = function(title)
				return title
			end,
			ui = {
				enabled = false,
				enable = false,
			},
			completion = {
				nvim_cmp = false,
				min_chars = 2,
			},
		},
	},
}
