return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = "modern",
    delay = 1000,
    },
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>e', group = '[E]xplorer' },
      { '<leader>f', group = '[F]ormat + [F]lutter' },
    },
}
