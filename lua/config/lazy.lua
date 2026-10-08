-- [[ LAZY.NVIM BOOTSTRAP ]]
-- Automatically download and install lazy.nvim if not present
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})

    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- [[ SETUP LAZY.NVIM ]]
-- Configure lazy.nvim to automatically import all plugin specs from lua/plugins/
--
-- HOW TO ADD NEW PLUGINS:
--   Option 1: Add your plugin to an existing category file in `lua/plugins/<category>.lua`.
--   Option 2: Create a new file in `lua/plugins/<name>.lua` returning a plugin spec table.
--             lazy.nvim will automatically detect and load it!
require('lazy').setup({
  spec = {
    -- Automatically load all plugin specifications from lua/plugins/
    { import = 'plugins' },
  },

  -- Fallback colorscheme when installing / bootstrapping plugins
  install = {
    colorscheme = { 'visual_studio_code', 'catppuccin', 'habamax' },
  },

  -- Automatically check for plugin updates in the background
  checker = {
    enabled = true,
  },
})
