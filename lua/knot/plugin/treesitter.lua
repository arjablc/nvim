local function patch_query_predicates_for_nvim_012()
	if vim.fn.has("nvim-0.12") == 0 then
		return
	end

	local query = require("vim.treesitter.query")
	local opts = { force = true, all = false }
	local html_script_type_languages = {
		importmap = "json",
		module = "javascript",
		["application/ecmascript"] = "javascript",
		["text/ecmascript"] = "javascript",
	}
	local non_filetype_match_injection_language_aliases = {
		ex = "elixir",
		pl = "perl",
		sh = "bash",
		uxn = "uxntal",
		ts = "typescript",
	}

	local function get_capture_node(match, capture_id)
		local node = match[capture_id]
		if type(node) == "table" then
			node = node[1]
		end
		if not node or type(node.range) ~= "function" then
			return nil
		end
		return node
	end

	local function get_parser_from_markdown_info_string(injection_alias)
		local match = vim.filetype.match({ filename = "a." .. injection_alias })
		return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
	end

	query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
		local node = get_capture_node(match, pred[2])
		local n = tonumber(pred[3])
		if node and n and node:parent() and node:parent():named_child_count() > n then
			return node:parent():named_child(n) == node
		end
		return false
	end, opts)

	query.add_predicate("is?", function(match, _pattern, bufnr, pred)
		local locals = require("nvim-treesitter.locals")
		local node = get_capture_node(match, pred[2])
		local types = { unpack(pred, 3) }
		if not node then
			return true
		end
		local _, _, kind = locals.find_definition(node, bufnr)
		return vim.tbl_contains(types, kind)
	end, opts)

	query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
		local node = get_capture_node(match, pred[2])
		local types = { unpack(pred, 3) }
		if not node then
			return true
		end
		return vim.tbl_contains(types, node:type())
	end, opts)

	query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
		local node = get_capture_node(match, pred[2])
		if not node then
			return
		end
		local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
		local configured = html_script_type_languages[type_attr_value]
		if configured then
			metadata["injection.language"] = configured
		else
			local parts = vim.split(type_attr_value, "/", {})
			metadata["injection.language"] = parts[#parts]
		end
	end, opts)

	query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
		local node = get_capture_node(match, pred[2])
		if not node then
			return
		end
		local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
		metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
	end, opts)

	query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
		local id = pred[2]
		local node = get_capture_node(match, id)
		if not node then
			return
		end
		local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
		metadata[id] = metadata[id] or {}
		metadata[id].text = string.lower(text)
	end, opts)
end

local function ensure_parsers_installed()
	local languages = {
		"c",
		"javascript",
		"jsdoc",
		"json",
		"jsonc",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"rst",
		"rust",
		"dart",
		"python",
		"go",
		"bash",
		"toml",
		"tsx",
		"typescript",
	}
	-- `install` is a no-op for already-installed parsers, but skip the call
	-- entirely once every requested language is available to avoid overhead.
	local missing = {}
	for _, lang in ipairs(languages) do
		if not pcall(vim.treesitter.language.add, lang) then
			missing[#missing + 1] = lang
		end
	end
	if #missing > 0 then
		require("nvim-treesitter").install(missing):wait(300000)
	end
end

local function enable_treesitter_on_filetype()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("knot.treesitter", { clear = true }),
		callback = function(args)
			local ok = pcall(vim.treesitter.start, args.buf)
			if not ok then
				return
			end
			vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo[0][0].foldmethod = "expr"
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})
		ensure_parsers_installed()
		patch_query_predicates_for_nvim_012()
		enable_treesitter_on_filetype()
	end,
}