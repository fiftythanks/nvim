return {
  { 'rauls-kjarners/omp.nvim', event = 'VeryLazy', opts = {} },

  -- AI Pair Programmer (CodeCompanion)
  {
    'olimorris/codecompanion.nvim',
    version = '*', -- Track stable releases
    lazy = false,
    keys = {
      { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle AI chat' },
      { '<leader>an', '<cmd>CodeCompanionChat<cr>', desc = 'New AI chat' },
      { '<leader>ap', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'x' }, desc = 'AI action palette' },
      { '<leader>ai', ':CodeCompanion<cr>', mode = 'x', desc = 'AI inline edit' },
      { '<leader>as', '<cmd>CodeCompanionChat Add<cr>', mode = 'x', desc = 'Add selection to AI chat' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      rules = {
        default = {
          files = { '.ai_system_prompt.md' },
        },
        opts = {
          chat = {
            autoload = 'default',
            enabled = true,
          },
        },
      },
      adapters = {
        acp = {
          omp = function()
            return require('codecompanion.adapters.acp').extend('goose', {
              name = 'omp',
              formatted_name = 'Oh My Pi',
              commands = { default = { 'omp', 'acp' } },
            })
          end,
          omp_inline = function()
            return require('codecompanion.adapters.acp').extend('goose', {
              name = 'omp_inline',
              formatted_name = 'Oh My Pi (Inline)',
              commands = {
                default = { 'omp', 'acp', '--approval-mode', 'yolo' },
              },
            })
          end,
        },
      },
      interactions = {
        chat = { adapter = 'omp' },
        inline = { adapter = 'omp_inline' },
      },
    },
  },

  -- Paste image from clipboard (useful with CodeCompanion and notes)
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = '[Image]($FILE_PATH)',
          use_absolute_path = true,
        },
      },
    },
    keys = {
      {
        '<leader>p',
        '<cmd>PasteImage<cr>',
        desc = 'Paste image from system clipboard',
      },
    },
  },
}
