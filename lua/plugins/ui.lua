return {
  -- VS Code Dark Theme
  {
    'askfiy/visual_studio_code',
    priority = 1000,
    opts = {
      mode = 'dark',
      hooks = {
        after = function()
          --- Helper function to safely add a style without erasing the theme's colors
          local function add_style(hl_group, style)
            local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
            hl[style] = true
            vim.api.nvim_set_hl(0, hl_group, hl)
          end

          -- =============================================
          -- TERMINAL STYLES (things terminal can display)
          -- =============================================
          add_style('@markup.strong', 'bold')
          add_style('@markup.italic', 'italic')
          add_style('@markup.underline', 'underline')
          add_style('@markup.strikethrough', 'strikethrough')

          -- Re-enable bold and italic for standard Markdown
          add_style('markdownBold', 'bold')
          add_style('markdownItalic', 'italic')

          -- ======================================================
          -- COLOUR STYLES (stuff terminals can't display natively)
          -- ======================================================
          -- Inline code
          vim.api.nvim_set_hl(
            0,
            '@neorg.markup.verbatim',
            { bg = '#2d2d30', fg = '#d4d4d4' }
          )

          -- Inline code that is a link
          local urlLinkHl = vim.api.nvim_get_hl(
            0,
            { name = '@markup.link.url', link = false }
          )
          local verbatimHl =
            vim.api.nvim_get_hl(0, { name = '@neorg.markup.verbatim' })

          vim.api.nvim_set_hl(0, '@markup.verbatim.link', {
            bg = verbatimHl.bg,
            fg = urlLinkHl.fg,
          })

          -- Inline code for standard Markdown and Lspsaga hover
          vim.api.nvim_set_hl(
            0,
            '@markup.raw.markdown_inline',
            { bg = '#2d2d30', fg = '#ce9178' }
          )
          vim.api.nvim_set_hl(
            0,
            '@markup.raw',
            { bg = '#2d2d30', fg = '#ce9178' }
          )
        end,
      },
    },
    config = function(_, opts)
      require('visual_studio_code').setup(opts)
      vim.defer_fn(function()
        vim.cmd([[colorscheme visual_studio_code]])
      end, 0)
    end,
  },

  -- Catppuccin Theme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha',
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
  },

  -- Web Devicons
  {
    'nvim-tree/nvim-web-devicons',
    opts = {},
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'askfiy/visual_studio_code',
    },
    opts = function()
      return {
        options = {
          theme = 'visual_studio_code',
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {},
          globalstatus = true,
          refresh = {
            statusline = 100,
          },
        },
        sections = require('visual_studio_code').get_lualine_sections(),
        extensions = {
          'fzf',
          'lazy',
          'man',
          'mason',
          'nvim-tree',
          'quickfix',
        },
      }
    end,
  },

  -- Colorful menu for completion highlights
  {
    'xzbdmw/colorful-menu.nvim',
    opts = {},
  },

  -- Deadcolumn (smart colorcolumn indicator)
  {
    'Bekaboo/deadcolumn.nvim',
    opts = {},
  },

  -- Color picker & highlighter
  {
    'uga-rosa/ccc.nvim',
    opts = {
      preserve = true,
      save_on_quit = true,
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
      recognize = {
        input = true,
        output = true,
      },
    },
    config = function(_, opts)
      require('ccc').setup(opts)
      vim.keymap.set('n', '<leader>cp', '<Cmd>CccPick<CR>', { desc = 'Color picker' })
      vim.keymap.set('n', '<leader>cc', '<Cmd>CccConvert<CR>', { desc = 'Color convert' })
    end,
  },
}
