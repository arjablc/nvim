return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = {'markdown'},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = {
        blink = {enabled = true}
      }
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",  
    lazy = true,
    event = {
      "BufReadPre /home/knot/Documents/notes_vault/*.md",
      "BufNewFile /home/knot/Documents/notes_vault/*.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    'MeanderingProgrammer/render-markdown.nvim',
    },
   opts = {
      workspaces = {
        {
          name = "notes",
          path = "/home/knot/Documents/notes_vault",
        },
      },
      completion = {
        nvim_cmp = false,
      },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        }
      },
      new_notes_location = "current_dir",
      note_id_func = function(title)
       local suffix = ''
            if title ~= nil then
              suffix = title:gsub(' ', '_'):gsub('[^A-Za-z0-9_-]', ''):lower()
            else
              for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90)) -- Random uppercase letters
              end
            end
            -- return os.time() .. '-' .. suffix -- Include a timestamp for uniqueness
            return '' .. suffix
        end,
      open_notes_in = "vsplit",
      ui = {
        enable = false,  
      },
    }
  }
}
