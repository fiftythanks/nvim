-- [[ AUTOCOMMANDS & USER COMMANDS ]]
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text (see `:h vim.hl.on_yank()`)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Open help windows on the left
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Open help windows on the left',
  pattern = 'help',
  callback = function()
    vim.cmd('wincmd H')
  end,
})

-- Native Tree-sitter highlighting for all files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable native Tree-sitter highlighting for all files',
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Save and restore folds across sessions
local saveFold = vim.api.nvim_create_augroup('PersistentFolds', {})

vim.api.nvim_create_autocmd('BufWinLeave', {
  group = saveFold,
  pattern = '*.*',
  callback = function()
    vim.cmd('silent! mkview')
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = saveFold,
  pattern = '*.*',
  callback = function()
    vim.cmd('silent! loadview')
  end,
})

-- LSP attach autocommands (completion & inlay hints)
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable vim.lsp.completion',
  callback = function(e)
    local clientId = vim.tbl_get(e, 'data', 'client_id')
    if clientId == nil then
      return
    end
    vim.lsp.completion.enable(true, clientId, e.buf)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable inlay hints',
  callback = function(e)
    local id = vim.tbl_get(e, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)

    if client == nil or not client:supports_method('textDocument/inlayHint') then
      return
    end

    vim.lsp.inlay_hint.enable(true, { bufnr = e.buf })
  end,
})

-- Format Rust files on save via LSP
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rs',
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Text wrap and color column at 80 characters
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.opt_local.textwidth = 80
    vim.o.colorcolumn = '80'
  end,
})

-- [[ USER COMMANDS ]]
-- Create a command `:GitBlameLine` that prints the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get current line number (see `:h line()`)
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.fn.system({
    'git',
    'blame',
    '-L',
    line_number .. ',+1',
    filename,
  }))
end, { desc = 'Print the git blame for the current line' })
