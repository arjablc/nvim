return {
	{
		"linux-cultist/venv-selector.nvim",
		ft = "python",
		cmd = "VenvSelect",
		keys = {
			{ "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
		},
		opts = {
			options = {
				notify_user_on_venv_activation = true,
				override_notify = false,
			},
		},
	},
}
