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

      vim.lsp.config('cssls', {
        filetypes = { 'css', 'less' },
      })

      vim.lsp.config('css_variables', {
        filetypes = { 'css', 'less' },
      })

      vim.lsp.config('somesass_ls', {
        root_markers = { '.git', 'package.json' },
        before_init = function(_, config)
          if not config.root_dir then
            return
          end
          local aliases = (config.settings and config.settings.somesass and config.settings.somesass.workspace and config.settings.somesass.workspace.importAliases) or {}
          aliases['@/'] = 'src/'
          local src_dir = vim.fs.joinpath(config.root_dir, 'src')
          local stat = vim.uv.fs_stat(src_dir)
          if stat and stat.type == 'directory' then
            local handle = vim.uv.fs_scandir(src_dir)
            if handle then
              while true do
                local name, typ = vim.uv.fs_scandir_next(handle)
                if not name then
                  break
                end
                if typ == 'directory' then
                  aliases['@/' .. name .. '/'] = 'src/' .. name .. '/'
                end
              end
            end
          end
          config.settings.somesass.workspace.importAliases = aliases
          config.settings.somesass.workspace.loadPaths = { 'src' }
        end,
        settings = {
          somesass = {
            workspace = {
              importAliases = {
                ['@/'] = 'src/',
                ['@/styles/'] = 'src/styles/',
                ['@/components/'] = 'src/components/',
                ['@/assets/'] = 'src/assets/',
                ['@/utils/'] = 'src/utils/',
                ['@/pages/'] = 'src/pages/',
                ['@/hooks/'] = 'src/hooks/',
                ['@/App/'] = 'src/App/',
              },
              loadPaths = { 'src' },
            },
            scss = {
              links = {
                enabled = true,
              },
              completion = {
                includeFromCurrentDocument = true,
              },
              hover = {
                enabled = true,
                documentation = true,
                references = true,
              },
            },
          },
        },
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
        'somesass_ls',
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
