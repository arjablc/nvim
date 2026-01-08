return {
	"nvim-mini/mini.nvim",
	version = "*",

	config = function()
		local MiniFiles = require("mini.files")

		MiniFiles.setup({
			options = {
				use_as_default_explorer = false,
			},
		})

		vim.keymap.set("n", "<leader>em", function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
		end, { desc = "Mini files (current file)" })

		vim.keymap.set("n", "<leader>eM", function()
			MiniFiles.open(vim.uv.cwd(), true)
		end, { desc = "Mini files (cwd)" })

		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()
		require("mini.ai").setup()

		require("mini.diff").setup({
			view = {
				style = "sign",
				signs = {
					add = "+",
					change = "~",
					delete = "-",
				},
			},
		})

		require("mini.jump").setup()

		require("mini.splitjoin").setup({
			mappings = {
				toggle = "sj",
			},
		})

		require("mini.icons").setup()
		MiniIcons.mock_nvim_web_devicons()

		require("mini.bracketed").setup()
		require("mini.statusline").setup()
		require("mini.sessions").setup()

		local BufRemove = require("mini.bufremove")
		BufRemove.setup({
			set_vim_settings = true,
		})

		vim.keymap.set("n", "<leader>bd", function()
			BufRemove.delete(0, false)
		end, { desc = "delete buffer" })

		vim.keymap.set("n", "<leader>bD", function()
			BufRemove.delete(0, true)
		end, { desc = "delete buffer(force)" })
	end,
}
