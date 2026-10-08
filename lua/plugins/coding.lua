return {
  -- Auto-close brackets and quotes
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      map_cr = true,
      enable_check_bracket_line = false,
      ignored_next_char = '[%w%.]',
      fast_wrap = {},
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)

      local npairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')
      local ts_conds = require('nvim-autopairs.ts-conds')

      -- Add trailing comma in Lua table constructors
      npairs.add_rules({
        Rule('{', '},', 'lua'):with_pair(
          ts_conds.is_ts_node({ 'table_constructor' })
        ),
      })
    end,
  },

  -- Surround text with quotes, brackets, tags, etc.
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {},
  },

  -- Commenting motions (gcc, gc in visual)
  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  -- Refactoring library (extract variable, inline variable, etc.)
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    lazy = false,
  },

  -- Highlight word under cursor throughout the buffer
  {
    'RRethy/vim-illuminate',
  },
}
