return {
  -- Fuzzy Finder (files, lsp, diagnostics, etc.)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      {
        'nvim-telescope/telescope-media-files.nvim',
        dependencies = {
          'nvim-lua/popup.nvim',
          'nvim-lua/plenary.nvim',
        },
      },
      {
        'cljoly/telescope-repo.nvim',
        dependencies = {
          'nvim-lua/plenary.nvim',
        },
      },
      {
        'prochri/telescope-all-recent.nvim',
        dependencies = {
          'kkharji/sqlite.lua',
        },
        opts = {},
      },
      {
        'jvgrootveld/telescope-zoxide',
      },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<C-h>'] = false, -- Backspace (delete char backward)
            ['<C-d>'] = false, -- Delete forward char (falls back to global keymap)
            ['<C-f>'] = false, -- Move forward char (falls back to global keymap)
            ['<C-u>'] = false, -- Clear prompt line (unix-line-discard)
            ['<C-k>'] = false, -- Kill to end of line (falls back to global keymap)
            ['<C-Down>'] = 'cycle_history_next',
            ['<C-Up>'] = 'cycle_history_prev',
            ['<M-n>'] = 'cycle_history_next',
            ['<M-p>'] = 'cycle_history_prev',
            ['<M-u>'] = 'preview_scrolling_up',
            ['<M-d>'] = 'preview_scrolling_down',
          },
        },
      },
      extensions = {
        repo = {
          list = {
            search_dirs = {
              '~/repos',
            },
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      telescope.load_extension('fzf')
      telescope.load_extension('media_files')
      telescope.load_extension('repo')
      telescope.load_extension('zoxide')

      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help Tags' })
      vim.keymap.set('n', '<leader>ft', builtin.treesitter, { desc = 'Find Treesitter Symbols' })
      vim.keymap.set('n', '<leader>fq', builtin.quickfixhistory, { desc = 'Find Quickfix History' })
      vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Find Marks' })
      vim.keymap.set('n', '<leader>fr', function()
        require('telescope').extensions.repo.list()
      end, { desc = 'Find Git Repositories' })
      vim.keymap.set('n', '<leader>fd', function()
        require('telescope').extensions.zoxide.list()
      end, { desc = 'Find Zoxide Directories' })
    end,
  },
}
