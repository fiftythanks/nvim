-- [[ OPTIONS ]]
-- General Neovim options and settings

-- Disable netrw (recommended for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Custom filetypes
vim.filetype.add({
  extension = {
    hl = 'hyprlang',
    mdx = 'mdx',
  },
  pattern = {
    ['hypr.*%.conf'] = 'hyprlang',
  },
})

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true -- Relative line numbers for easy jumping (see `:h number_relativenumber`)

-- Sync clipboard between OS and Neovim (scheduled after UiEnter for faster startup)
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Cursor and scrolling
vim.o.cursorline = true
vim.o.scrolloff = 10 -- Minimal number of screen lines to keep above and below cursor

-- Whitespace display
vim.o.list = true
vim.opt.listchars = { tab = '> ', trail = '+', nbsp = '␣' }

-- Confirmation dialog on unsaved changes
vim.o.confirm = true

-- Indentation (tabs vs spaces)
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Line wrapping
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakat = ' \t-'

-- Undo persistence
vim.o.undofile = true

-- Live substitution preview
vim.o.inccommand = 'split'

-- Colors & UI
vim.opt.termguicolors = true
vim.o.foldlevelstart = 99
vim.o.signcolumn = 'yes'
vim.o.conceallevel = 2

-- Completion menu
vim.opt.completeopt = { 'menuone', 'noinsert' }
vim.opt.shortmess:append('c')

-- Diagnostic configuration
vim.diagnostic.config({
  severity_sort = true,
  float = { source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  jump = {
    on_jump = function()
      vim.diagnostic.open_float({ focus = false })
    end,
  },
})

-- Optional packages
vim.cmd('packadd! nohlsearch')
