return {
  'folke/todo-comments.nvim',
  cmd = { 'TodoTelescope' },
  event = { 'BufReadPre' },

  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require("todo-comments").setup({
      signs = true
    })
    vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", {desc = "Search Todos"})
  end
}
