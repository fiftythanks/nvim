return {
  -- Treesitter syntax parsing
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    opts = {
      highlight = { enable = true },
    },
    config = function(_, opts)
      local ts = require('nvim-treesitter')
      ts.setup(opts)

      ts.install({
        'bash',
        'css',
        'diff',
        'ecma',
        'hyprlang',
        'javascript',
        'typescript',
        'jsdoc',
        'json',
        'jsx',
        'tsx',
        'latex',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'regex',
        'scss',
        'typst',
        'yaml',
        'rust',
        'toml',
        'python',
        'ninja',
        'rst',
      })
    end,
  },

  -- Treesitter textobjects (syntax-aware motions & text objects)
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    opts = {
      move = {
        set_jumps = true,
      },
      select = {
        lookahead = true,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter-textobjects').setup(opts)

      local select =
        require('nvim-treesitter-textobjects.select').select_textobject

      -- Function & class selections
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        select('@function.outer', 'textobjects')
      end, { desc = 'Select around function' })
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        select('@function.inner', 'textobjects')
      end, { desc = 'Select inside function' })
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        select('@class.outer', 'textobjects')
      end, { desc = 'Select around class' })
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        select('@class.inner', 'textobjects')
      end, { desc = 'Select inside class' })

      -- Parameter swapping
      local swap = require('nvim-treesitter-textobjects.swap')
      vim.keymap.set('n', '<leader>sn', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap next parameter' })
      vim.keymap.set('n', '<leader>sp', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap previous parameter' })
      vim.keymap.set('n', '<leader>Sn', function()
        swap.swap_next('@parameter.outer')
      end, { desc = 'Swap next parameter (outer)' })
      vim.keymap.set('n', '<leader>Sp', function()
        swap.swap_previous('@parameter.outer')
      end, { desc = 'Swap previous parameter (outer)' })

      -- Motion jumps
      local move = require('nvim-treesitter-textobjects.move')
      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next class start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
        move.goto_next_start('@loop.inner', '@loop.outer')
      end, { desc = 'Next loop start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
        move.goto_next_start('@local.scope', 'locals')
      end, { desc = 'Next scope start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        move.goto_next_start('@fold', 'folds')
      end, { desc = 'Next fold start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
        move.goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Next function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        move.goto_next_end('@class.outer', 'textobjects')
      end, { desc = 'Next class end' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Previous function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end, { desc = 'Previous class start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
        move.goto_previous_end('@function.outer', 'textobjects')
      end, { desc = 'Previous function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        move.goto_previous_end('@class.outer', 'textobjects')
      end, { desc = 'Previous class end' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
        move.goto_next('@conditional.outer', 'textobjects')
      end, { desc = 'Next conditional' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
        move.goto_previous('@conditional.outer', 'textobjects')
      end, { desc = 'Previous conditional' })

      -- Repeatable moves
      local repeatMove = require('nvim-treesitter-textobjects.repeatable_move')
      vim.keymap.set({ 'n', 'x', 'o' }, ';', repeatMove.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', repeatMove.repeat_last_move_previous)
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', repeatMove.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', repeatMove.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', repeatMove.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', repeatMove.builtin_T_expr, { expr = true })
    end,
  },
}
