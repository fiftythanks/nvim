return {
  -- Debug Adapter Protocol (DAP) core
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')

      local codelldb_path = vim.g.codelldb_path
        or (vim.fn.exepath('codelldb') ~= '' and vim.fn.exepath('codelldb'))
        or '/opt/codelldb/extension/adapter/codelldb'

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = codelldb_path,
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.rust = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input(
              'Path to executable: ',
              vim.fn.getcwd() .. '/target/debug/',
              'file'
            )
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      -- Debugging Keymaps
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'DAP Continue' })
      vim.keymap.set('n', '<F6>', function()
        dap.disconnect({ terminateDebuggee = true })
      end, { desc = 'DAP Disconnect' })
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'DAP Step Over' })
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'DAP Step Into' })
      vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'DAP Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'DAP Toggle Breakpoint' })
    end,
  },

  -- UI for nvim-dap
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    opts = {},
  },

  -- Python DAP integration
  {
    'mfussenegger/nvim-dap-python',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dap-python').test_runner = 'pytest'
    end,
  },

  -- Task runner and job manager
  {
    'stevearc/overseer.nvim',
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {},
    config = function(_, opts)
      local overseer = require('overseer')
      overseer.setup(opts)

      vim.keymap.set('n', '<leader>o', overseer.toggle, { desc = 'Toggle Overseer' })
      vim.keymap.set('n', '<leader>R', overseer.run_template, { desc = 'Overseer Run Template' })
    end,
  },
}
