return {
  "nvim-mini/mini.nvim",
  version = "*",
  config = function()
    local MiniFiles = require("mini.files")

    MiniFiles.setup({
      options = {
        use_as_default_explorer = true,
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
    require("mini.diff").setup()
    require("mini.jump").setup()

    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()

    require("mini.bracketed").setup()
    require("mini.statusline").setup()

    local remove_buf = require("mini.bufremove").setup()
    vim.keymap.set("n", "<leader>bd", function()
      remove_buf.delete(0, false)
    end,
    {desc = "delete buffer"})

    vim.keymap.set("n", "<leader>bD", function()
      remove_buf.delete(0, true)
    end,
    {desc = "delete buffer(force)"})

  local miniclue = require('mini.clue')
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },
      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      -- Window commands
      { mode = 'n', keys = '<C-w>' },
      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      -- Custom keymaps
      { mode = 'n', keys = '<Leader>e', desc = '[E]xplorer' },
      { mode = 'n', keys = '<Leader>b', desc = '[B]uffer' },
      
    },
  })
  end,
}
