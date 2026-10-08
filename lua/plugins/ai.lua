return {
  -- AI Pair Programmer (CodeCompanion)
  {
    'olimorris/codecompanion.nvim',
    version = '~18', -- Pin to v18.x
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'viespejo/cc-adapter-vertex-ai.nvim',
    },
    opts = {
      rules = {
        default = {
          files = { '.ai_system_prompt.md' },
          is_present = true,
        },
        opts = {
          chat = {
            autoload = 'default',
            enabled = true,
          },
        },
      },
      adapters = {
        http = {
          vertex_gemini = function()
            return require('codecompanion.adapters').extend(
              require('codecompanion.adapters.http.vertex-gemini'),
              {
                env = {
                  project_id = vim.env.VERTEX_PROJECT_ID
                    or vim.g.vertex_project_id
                    or 'your-gcp-project-id',
                  region = vim.env.VERTEX_REGION
                    or vim.g.vertex_region
                    or 'global',
                },
              }
            )
          end,
        },
      },
      interactions = {
        chat = { adapter = 'vertex_gemini' },
        inline = {
          adapter = 'vertex_gemini',
        },
      },
    },
  },

  -- GitHub Copilot
  {
    'zbirenbaum/copilot.lua',
    dependencies = { 'copilotlsp-nvim/copilot-lsp' },
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = false, -- Disables default <M-CR> / <C-CR> panel trigger
        },
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
