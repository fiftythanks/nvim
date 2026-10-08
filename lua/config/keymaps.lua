-- [[ KEYMAPS ]]
-- General Neovim keymaps (plugin-specific keymaps live in their respective plugin files)

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {
  desc = 'Open diagnostic [Q]uickfix list',
})
vim.keymap.set('n', ']e', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Next error' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Previous error' })

-- Terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation in any mode (<A-h>, <A-j>, <A-k>, <A-l>)
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')

-- Insert mode scrolling & character copying
vim.keymap.set('i', '<C-S-e>', '<C-e>')
vim.keymap.set('i', '<C-S-y>', '<C-y>')
vim.keymap.set('i', '<C-e>', '<C-x><C-e>')
vim.keymap.set('i', '<C-y>', '<C-x><C-y>')

-- Readline-style navigation in Insert and Command-line modes
vim.keymap.set({ 'i', 'c' }, '<C-a>', '<Home>')
vim.keymap.set({ 'i', 'c' }, '<C-e>', '<End>')
vim.keymap.set({ 'i', 'c' }, '<C-b>', '<Left>')
vim.keymap.set({ 'i', 'c' }, '<C-f>', '<Right>')
vim.keymap.set({ 'i', 'c' }, '<C-d>', '<Del>')

-- Word navigation in Command-line mode
vim.keymap.set('c', '<Esc><C-b>', '<S-Left>')
vim.keymap.set('c', '<Esc><C-f>', '<S-Right>')

-- Visual mode helper: wrap selection in an anonymous function
vim.keymap.set('x', '<leader>wf', [[cfunction() <C-r>"() end<ESC>]], {
  desc = 'Wrap selection in anonymous function',
})

-- Tab and Window helpers
vim.keymap.set('n', '<leader><C-q>', '<Cmd>tabclose<CR>', {
  desc = 'Close current tab page',
})
vim.keymap.set('n', '<C-w>n', '<Cmd>vnew<CR>', {
  desc = 'Create a vertical split new buffer',
})
