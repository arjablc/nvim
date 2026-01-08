return {
	"akinsho/flutter-tools.nvim",
	ft = "dart",
	config = function()
		require("flutter-tools").setup({
			lsp = {
				color = {
					enable = true,
					foreground = true,
				},
			},
			debugger = {
				enable = true,
				-- register_configurations = function(paths)
				-- local dap = require('dap')
				-- dap.adapters.dart = {
				-- 	type = "executable",
				-- 	command = paths.flutter_bin,
				-- 	args = { "debug-adapter" },
				-- }
				-- dap.configurations.dart = {
				-- 	--put here config that you would find in .vscode/launch.json
				-- }
				-- If you want to load .vscode launch.json automatically run the following:
				-- require("dap.ext.vscode").load_launchjs()
				-- end,
			},
			dev_log = {
				enabled = true,
				filter = nil, -- optional callback to filter the log
				notify_errors = false, -- if there is an error whilst running then notify the user
				open_cmd = "botright 10split", -- command to use to open the log buffer
				focus_on_open = true, -- focus on the newly opened log window
			},
		})
		vim.keymap.set("n", "<leader>fl", require("telescope").extensions.flutter.commands, { desc = "flutter tools" })
		vim.keymap.set("n", "<leader>fd", "<cmd>FlutterLogToggle<CR>", { desc = "flutter logs" })

		vim.keymap.set("n", "<leader>fp", function()
			local name = vim.fn.expand("%:t:r") -- file name without extension
			local line = ('part "%s._.dart";'):format(name)

			local row = vim.api.nvim_win_get_cursor(0)[1]
			vim.api.nvim_buf_set_lines(0, row, row, true, { line })

			local col = #('part "' .. name .. ".")
			vim.api.nvim_win_set_cursor(0, { row + 1, col })
			vim.api.nvim_feedkeys("ciw", "n", false)
		end, { desc = "Flutter path" })
	end,
}
