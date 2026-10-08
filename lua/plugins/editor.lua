return {
  -- File explorer tree
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      filters = {
        git_ignored = false,
      },
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)

      local tree = require('nvim-tree.api').tree
      vim.keymap.set('n', '<leader>tt', tree.toggle, { desc = 'Toggle file tree' })
      vim.keymap.set('n', '<leader>tf', tree.find_file, { desc = 'Find file in tree' })
    end,
  },

  -- Diagnostics, references, and telescope list viewer
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<Cmd>Trouble diagnostics toggle<CR>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<Cmd>Trouble symbols toggle focus=false<CR>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<Cmd>Trouble lsp toggle focus=false win.position=right<CR>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<Cmd>Trouble loclist toggle<CR>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<Cmd>Trouble qflist toggle<CR>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },

  -- Highlight and search TODO / FIX / NOTE comments
  {
    'folke/todo-comments.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      keywords = {
        ['DILEMMA'] = {
          icon = '',
          color = 'info',
        },
      },
    },
  },

  -- Nerd Font glyph / icon picker
  {
    '2kabhishek/nerdy.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    lazy = false,
    cmd = 'Nerdy',
    opts = {
      max_recents = 30,
      copy_to_clipboard = true,
      copy_register = '+',
    },
    config = function(_, opts)
      require('nerdy').setup(opts)

      vim.keymap.set('n', '<leader>bi', '<Cmd>Nerdy list<CR>', { desc = 'Browse icons' })
      vim.keymap.set('n', '<leader>ri', '<Cmd>Nerdy recents<CR>', { desc = 'Browse recent icons' })
    end,
  },

  -- Highlight range in command line (e.g. :10,20s/...)
  {
    'winston0410/range-highlight.nvim',
    event = { 'CmdlineEnter' },
    opts = {
      excluded = {
        cmd = {
          'substitute',
        },
      },
    },
  },

  -- Auto-change directory to project root
  {
    'wsdjeg/rooter.nvim',
    opts = {
      root_pattern = { '.git/' },
    },
  },

  -- Zoxide integration for Vim
  {
    'nanotee/zoxide.vim',
  },
}
