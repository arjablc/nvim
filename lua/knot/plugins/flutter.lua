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
				open_cmd = "botright split", -- command to use to open the log buffer
				focus_on_open = true, -- focus on the newly opened log window
			},
		})
		vim.keymap.set("n", "<leader>fl", require("telescope").extensions.flutter.commands, { desc = "flutter tools" })
		vim.keymap.set("n", "<leader>fd", "<cmd>FlutterLogToggle<CR>", { desc = "flutter logs" })

		vim.keymap.set("n", "<leader>cf", function()
			local filename = vim.fn.expand("%:t") -- e.g. MyFile.dart
			local dot_pos = filename:match(".*()%.") or #filename + 1
			vim.api.nvim_put({ filename:sub(1, dot_pos - 1) }, "c", true, true)
			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			vim.api.nvim_win_set_cursor(0, { row, dot_pos - 1 })
		end, { desc = "Insert filename without extension" })
	end,
}
