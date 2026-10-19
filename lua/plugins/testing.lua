return {
  -- Testing framework
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'folke/trouble.nvim',
      {
        'thenbe/neotest-playwright',
        dependencies = 'nvim-telescope/telescope.nvim',
      },
      'nvim-neotest/neotest-python',
    },
    config = function(_, opts)
      opts.adapters = {
        require('neotest-jest')({
          jestCommand = 'bun run test --',
          jestArguments = function(defaultArguments, _)
            return defaultArguments
          end,
          jestConfigFile = 'jest.config.ts',
          env = {},
          cwd = function(_)
            return vim.fn.getcwd()
          end,
          isTestFile = require('neotest-jest.jest-util').defaultIsTestFile,
        }),
        require('neotest-vitest'),
        require('neotest-playwright').adapter({
          options = {
            is_test_file = function(file_path)
              local result = file_path:find('e2e/.*%.spec.ts$') ~= nil
              return result
            end,
            experimental = {
              telescope = {
                enabled = true,
                opts = {},
              },
            },
          },
        }),
        require('neotest-python'),
      }

      -- Test Keymaps
      vim.keymap.set('n', '<leader>to', function()
        require('neotest').output.open({ enter = true })
      end, { desc = 'Open test output' })

      vim.keymap.set('n', '<leader>tp', function()
        require('neotest').output_panel.toggle()
      end, { desc = 'Toggle test output panel' })

      vim.keymap.set('n', '<leader>rt', function()
        require('neotest').run.run()
      end, { desc = 'Run nearest test' })

      vim.keymap.set('n', '<leader>rs', function()
        require('neotest').run.run(vim.fn.expand('%'))
      end, { desc = 'Run test suite' })

      vim.keymap.set('n', '<leader>rl', function()
        require('neotest').run.run_last()
      end, { desc = 'Rerun last test' })

      vim.keymap.set('n', '<leader>st', function()
        require('neotest').run.stop()
      end, { desc = 'Stop running test' })

      vim.keymap.set('n', '<leader>tw', function()
        require('neotest').watch.toggle()
      end, { desc = 'Toggle test watch' })

      vim.keymap.set('n', '<leader>ts', function()
        require('neotest').summary.toggle()
      end, { desc = 'Toggle test summary' })

      require('neotest').setup(opts)
    end,
  },
}
