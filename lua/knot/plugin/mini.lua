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

		-- Track the window you launched MiniFiles from (so we never :edit inside explorer)
		vim.g.minifiles_opener_win = nil

		vim.keymap.set("n", "<leader>em", function()
			vim.g.minifiles_opener_win = vim.api.nvim_get_current_win()
			MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
		end, { desc = "Mini files (current file)" })

		vim.keymap.set("n", "<leader>eM", function()
			vim.g.minifiles_opener_win = vim.api.nvim_get_current_win()
			MiniFiles.open(vim.uv.cwd(), true)
		end, { desc = "Mini files (cwd)" })

		-- --------------------------------------------------------------------
		-- MiniFiles extras:
		-- - open in split / vsplit
		-- - open PDFs in zathura
		-- - help menu inside MiniFiles (press ?)
		-- --------------------------------------------------------------------
		local function ends_with(str, suffix)
			return suffix == "" or str:sub(-#suffix) == suffix
		end

		local function get_target_win_fallback(explorer_win)
			-- 1) Prefer the stored opener window (most reliable)
			local w = vim.g.minifiles_opener_win
			if type(w) == "number" and vim.api.nvim_win_is_valid(w) and w ~= explorer_win then
				return w
			end

			-- 2) Prefer MiniFiles' target window if your version provides it
			local ok, win = pcall(MiniFiles.get_target_window)
			if ok and type(win) == "number" and vim.api.nvim_win_is_valid(win) and win ~= explorer_win then
				return win
			end

			-- 3) Alternate/previous window
			local alt = vim.fn.win_getid(vim.fn.winnr("#"))
			if alt ~= 0 and vim.api.nvim_win_is_valid(alt) and alt ~= explorer_win then
				return alt
			end

			-- 4) Hard fallback: go to previous window if possible
			pcall(vim.cmd, "wincmd p")
			local cur = vim.api.nvim_get_current_win()
			if cur ~= explorer_win then
				return cur
			end

			-- 5) Absolute last resort: return opener even if it's invalid (will be checked)
			return w
		end

		local function open_help()
			local lines = {
				"mini.files help",
				"",
				"Enter / l : open (edit) / go in directory",
				"s         : open in horizontal split",
				"v         : open in vertical split",
				"p         : open PDF in zathura (files ending with .pdf)",
				"?         : this help",
				"",
				"Tip: split open targets the window you opened MiniFiles from.",
			}

			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.bo[buf].bufhidden = "wipe"
			vim.bo[buf].modifiable = false
			vim.bo[buf].filetype = "help"

			local width = 60
			local height = #lines
			local opts = {
				relative = "editor",
				style = "minimal",
				border = "rounded",
				width = width,
				height = height,
				row = math.floor((vim.o.lines - height) / 2),
				col = math.floor((vim.o.columns - width) / 2),
			}

			local win = vim.api.nvim_open_win(buf, true, opts)
			vim.keymap.set("n", "q", function()
				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end
			end, { buffer = buf, nowait = true, silent = true, desc = "Close help" })
		end

		local function open_entry(opts)
			opts = opts or {}
			local entry = MiniFiles.get_fs_entry()
			if not entry or not entry.path then
				return
			end

			-- Directory: just go in
			if entry.fs_type == "directory" then
				MiniFiles.go_in()
				return
			end

			local path = entry.path

			-- PDF -> zathura
			if opts.zathura_pdf and ends_with(path:lower(), ".pdf") then
				vim.fn.jobstart({ "zathura", path }, { detach = true })
				return
			end

			-- The window you're currently in is the explorer window
			local explorer_win = vim.api.nvim_get_current_win()

			-- Choose a non-explorer target window
			local target = get_target_win_fallback(explorer_win)

			-- If we still couldn't get a valid non-explorer window, force a split outside
			if not (type(target) == "number" and vim.api.nvim_win_is_valid(target) and target ~= explorer_win) then
				-- jump out of explorer window if possible
				pcall(vim.cmd, "wincmd p")
				-- create a new split if we still didn't move
				if vim.api.nvim_get_current_win() == explorer_win then
					vim.cmd("split")
				end
				target = vim.api.nvim_get_current_win()
			else
				vim.api.nvim_set_current_win(target)
			end

			if opts.cmd == "split" then
				vim.cmd("split")
			elseif opts.cmd == "vsplit" then
				vim.cmd("vsplit")
			end

			vim.cmd("edit " .. vim.fn.fnameescape(path))

			-- Close explorer after opening a file
			pcall(MiniFiles.close)
		end

		-- Buffer-local mappings for MiniFiles
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesBufferCreate",
			callback = function(args)
				local buf = args.data.buf_id

				vim.keymap.set("n", "l", function()
					open_entry({ cmd = "edit" })
				end, { buffer = buf, nowait = true, silent = true, desc = "Open/go in" })

				vim.keymap.set("n", "<CR>", function()
					open_entry({ cmd = "edit" })
				end, { buffer = buf, nowait = true, silent = true, desc = "Open/go in" })

				vim.keymap.set("n", "s", function()
					open_entry({ cmd = "split" })
				end, { buffer = buf, nowait = true, silent = true, desc = "Open in split" })

				vim.keymap.set("n", "v", function()
					open_entry({ cmd = "vsplit" })
				end, { buffer = buf, nowait = true, silent = true, desc = "Open in vsplit" })

				vim.keymap.set("n", "p", function()
					open_entry({ zathura_pdf = true })
				end, { buffer = buf, nowait = true, silent = true, desc = "Open PDF in zathura" })

				vim.keymap.set("n", "?", function()
					open_help()
				end, { buffer = buf, nowait = true, silent = true, desc = "Help" })
			end,
		})

		-- Your other mini modules
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
