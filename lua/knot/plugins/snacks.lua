return {
	"folke/snacks.nvim",
	config = function()
		require("snacks").setup({
			scroll = {},
			lazygit = {},
			toggle = {},
			indent = {},
			animate = {},
			notifier = {},
			image = {},
			dashboard = {
				enabled = true,

				preset = {
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = function()
								Snacks.dashboard.pick("live_grep")
							end,
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = function()
								Snacks.dashboard.pick("oldfiles")
							end,
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = function()
								Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath("config") })
							end,
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{
							icon = "󰒲 ",
							key = "L",
							desc = "Lazy",
							action = ":Lazy",
							enabled = package.loaded.lazy ~= nil,
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},

				sections = {
					{ section = "header" },
					{
						section = "keys",
						indent = 1,
						padding = 1,
					},
					{
						section = "recent_files",
						icon = " ",
						title = "Recent Files",
						indent = 3,
						padding = 2,
					},
					{ section = "startup" },
				},
			},
		})
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { desc = "Snacks: " .. desc })
		end

		map("<leader>gl", function()
			Snacks.lazygit()
		end, "lazygit")
		map("<leader>nh", function()
			Snacks.notifier.show_history()
		end, "Notification History")
		map("<leader>bd", function()
			Snacks.bufdelete()
		end, "Buffer Delete")
		map("<leader>nd", function()
			Snacks.notifier.hide()
		end, "Buffer Delete")
		map("<leader>ee", function()
			Snacks.picker.hide()
		end, "Buffer Delete")

		Snacks.toggle.animate():map("<leader>tA")
		Snacks.toggle.zen():map("<leader>tz")
		Snacks.toggle.indent():map("<leader>ti")
		Snacks.toggle
			.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
			:map("<leader>tc")
		Snacks.toggle.inlay_hints():map("<leader>th")
		Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
		Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
	end,
}
