-- all the oneliner plugins are placed here including dependencies like plenary
return {
  "nvim-lua/plenary.nvim", 
  "christoomey/vim-tmux-navigator", 
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  }
}
