return {
  -- Code formatting
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        bash = { 'shfmt' },
        lua = { 'stylua' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        css = { 'prettierd', 'stylelint' },
        scss = { 'prettierd', 'stylelint' },
        html = { 'prettierd' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        toml = { 'taplo' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
      },
      format_on_save = {
        lsp_format = 'fallback',
      },
      formatters = {
        stylua = {
          prepend_args = {
            '--column-width',
            '80',
            '--indent-type',
            'Spaces',
            '--indent-width',
            '2',
            '--quote-style',
            'AutoPreferSingle',
          },
        },
      },
    },
  },

  -- Code linting
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        yaml = { 'actionlint', 'yamllint' },
        lua = { 'luacheck' },
        makrdown = { 'mado' },
        bash = { 'shellcheck' },
      }
    end,
  },
}
