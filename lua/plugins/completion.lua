return {
  -- Modern completion engine
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'folke/lazydev.nvim',
      {
        'mikavilpas/blink-ripgrep.nvim',
        version = '*',
      },
      { 'yus-works/csc.nvim', opts = {} },
    },
    version = '1.*',
    build = 'cargo build --release',
    opts = {
      keymap = {
        preset = 'enter',
        ['<C-k>'] = false,
        ['<C-u>'] = { 'scroll_signature_up', 'fallback' },
        ['<C-d>'] = { 'scroll_signature_down', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = {
          auto_show = true,
        },
        list = {
          selection = {
            auto_insert = false,
            preselect = false,
          },
        },
        menu = {
          draw = {
            columns = { { 'kind_icon' }, { 'label', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'buffer',
          'lazydev',
          'ripgrep',
        },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          ripgrep = {
            module = 'blink-ripgrep',
            name = 'Ripgrep',
            opts = {
              backend = {
                use = 'gitgrep',
              },
            },
          },
        },
        per_filetype = {
          codecompanion = { 'codecompanion' },
        },
      },
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
      },
      signature = {
        enabled = true,
      },
    },
    opts_extend = { 'sources.default' },
  },
}
