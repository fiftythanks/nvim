-- ========================================================================== --
--                             NEOVIM CONFIGURATION                           --
-- ========================================================================== --

-- NOTE: Leader keys MUST be set before loading plugins or mappings,
-- otherwise the wrong leader will be used by plugins.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Optional local machine settings (ignored by Git)
pcall(require, 'config.local')

-- Core settings (options, keymaps, autocommands)
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Plugin manager (lazy.nvim)
require('config.lazy')

-- Default colorscheme
pcall(vim.cmd.colorscheme, 'visual_studio_code')
