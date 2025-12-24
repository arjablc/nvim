return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
		opts = {},
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		lazy = true,
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/Documents/notes_vault/**.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/Documents/notes_vault/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "notes_vault",
					path = "~/Documents/notes_vault/",
				},
			},
			new_notes_location = "current_dir",
			open_notes_in = "vsplit",
			ui = {
				enable = false,
			},
			completion = {
				nvim_cmp = false,
				min_chars = 2,
			},
		},
		config = function()
			vim.keymap.set("n", "gf", "<cmd>ObsidianFollowLink<CR>", { desc = "Obsidian follow link" })
		end,
	},
}
