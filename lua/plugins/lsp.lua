return {
  -- LSP Configuration & Management
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      -- ==================================================================== --
      --                       LSP SERVER CONFIGURATIONS                      --
      -- ==================================================================== --

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'require', 'vim' },
            },
          },
        },
      })

      vim.lsp.config('stylelint_lsp', {
        settings = {
          stylelint = {
            validate = { 'css', 'scss' },
          },
        },
      })

      vim.lsp.config('eslint', {
        settings = {
          eslint = {
            execArgv = { '--max-old-space-size=8192' },
          },
        },
      })

      vim.lsp.config('hyprls', {
        root_dir = vim.fn.getcwd(),
        filetypes = { 'hyprlang' },
        settings = {
          hyprls = {
            preferIgnoreFile = true,
            ignore = { 'hyprlock.conf', 'hypridle.conf' },
          },
        },
      })

      vim.lsp.config('yamlls', {
        filetypes = { 'yaml' },
      })

      vim.lsp.config('marksman', {
        filetypes = { 'markdown', 'mdx' },
      })

      -- ==================================================================== --
      --                          CAPABILITIES SETUP                          --
      -- ==================================================================== --
      -- Enable snippet capability and merge with blink.cmp capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- ==================================================================== --
      --                        ENABLED LANGUAGE SERVERS                      --
      -- ==================================================================== --
      -- Add any new LSP server name to this list to enable it
      vim.lsp.enable({
        'lua_ls',
        'bashls',
        'css_variables',
        'cssls',
        'jsonls',
        'marksman',
        'systemd_lsp',
        'yamlls',
        'gh_actions_ls',
        'stylelint_lsp',
        'emmet_language_server',
        'eslint',
        'hyprls',
        'basedpyright',
        'ruff',
      })
    end,
  },

  -- Portable package manager for Neovim (LSP, DAP, linters, formatters)
  {
    'mason-org/mason.nvim',
    opts = {},
  },

  -- Enhanced LSP UI (code actions, breadcrumbs, hover, outline)
  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      code_action = {
        show_server_name = true,
      },
      lightbulb = {
        virtual_text = false,
      },
      outline = {
        layout = 'float',
      },
      symbols_in_winbar = {
        enable = true,
      },
      hover = {
        max_width = 1.0,
      },
    },
    config = function(_, opts)
      require('lspsaga').setup(opts)
      vim.keymap.set('n', '<leader>.', '<cmd>Lspsaga code_action<CR>', {
        desc = 'LSP Code Action',
      })
    end,
  },

  -- Lua development helper (proper types for Neovim config & plugins)
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        {
          path = '${3rd}/luv/library',
          words = { 'vim%.uv' },
        },
        'nvim-dap-ui',
        'rustaceanvim',
      },
    },
  },

  -- Incremental LSP rename with live preview
  {
    'smjonas/inc-rename.nvim',
    opts = {},
    config = function(_, opts)
      require('inc_rename').setup(opts)
      vim.keymap.set('n', '<leader>rn', function()
        return ':IncRename ' .. vim.fn.expand('<cword>')
      end, { expr = true, desc = 'Incremental Rename' })
    end,
  },

  -- TypeScript / JavaScript LSP enhancements
  {
    'pmizio/typescript-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
      },
      settings = {
        complete_function_calls = true,
      },
    },
  },
}
