return {
  -- Rust enhancements (rust-analyzer, debugging, and tools)
  {
    'mrcjkb/rustaceanvim',
    lazy = false,
    init = function()
      ---@type rustaceanvim.Opts
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                enable = true,
                disabled = { 'unresolved-proc-macro' },
                experimental = {
                  enable = true,
                },
                styleLints = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
              -- Limit the memory RA uses for caching
              lru = {
                capacity = 128,
              },
              files = {
                exclude = { 'target' },
              },
            },
          },
        },
      }

      -- Other Rust formatting options
      vim.g.rustfmt_emit_files = 1
      vim.g.rustfmt_detect_version = 1
      vim.g.rustfmt_find_toml = 1
    end,
  },

  -- Python virtual environment selector
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    ft = 'python',
    keys = { { ',v', '<cmd>VenvSelect<cr>', desc = 'Select Python venv' } },
    opts = {
      options = {},
      search = {},
    },
  },
}
