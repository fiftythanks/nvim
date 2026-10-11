return {
  -- Markdown inline previewer and decorator
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = { 'saghen/blink.cmp' },
    opts = {
      preview = {
        enable = true,
        enable_hybrid_mode = true,
        filetypes = {
          'markdown',
          'quarto',
          'python',
          'codecompanion',
        },
        modes = { 'n', 'no', 'c' },
        hybrid_modes = { 'n' },
        max_buf_lines = 1000,
        ignore_buftypes = {},
      },
      markdown_inline = {
        enable = true,
        checkboxes = {
          enable = true,
        },
        hyperlinks = {
          enable = true,
          default = {
            icon = '',
            hl = 'MarkviewHyperlink',
          },
        },
      },
      markdown = {
        inline_elements = true,
      },
    },
  },

  -- Store plugin for markview
  {
    'alex-popov-tech/store.nvim',
    dependencies = { 'OXY2DEV/markview.nvim' },
    opts = {},
    cmd = 'Store',
  },

  -- Obsidian note-taking integration
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      ui = { enable = false },
      workspaces = {
        {
          name = 'obsidian',
          path = '~/repos/obsidian/',
        },
      },
    },
  },

  -- Neorg ecosystem
  {
    'nvim-neorg/neorg',
    lazy = false,
    version = '*',
    dependencies = {
      'nvim-neorg/tree-sitter-norg',
      'nvim-neorg/tree-sitter-norg-meta',
      'benlubas/neorg-conceal-wrap',
    },
    opts = {
      load = {
        ['core.defaults'] = {},
        ['core.summary'] = {},
        ['core.concealer'] = {
          config = {
            icon_preset = 'diamond',
            icons = {
              todo = {
                uncertain = {
                  icon = '',
                },
              },
            },
          },
        },
        ['core.dirman'] = {
          config = {
            workspaces = {
              default = '~/repos/neorg/main',
              projects = '~/repos/neorg/projects',
              diary = '~/repos/neorg/diary',
            },
            default_workspace = 'default',
          },
        },
        ['core.journal'] = {
          config = {
            journal_folder = 'daily_notes',
            template_name = 'daily_note_template.norg',
            workspace = 'diary',
            use_template = true,
          },
        },
        ['core.itero'] = {
          config = {},
        },
      },
    },
    config = function(_, opts)
      require('neorg').setup(opts)

      vim.keymap.set(
        'n',
        '<leader>ll',
        '<Plug>(neorg.qol.todo-items.todo.task-cycle)',
        { desc = 'Cycle Neorg task' }
      )

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'norg',
        callback = function()
          vim.opt_local.wrap = false
        end,
      })
    end,
  },
}
