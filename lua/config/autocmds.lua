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

    if
      client == nil or not client:supports_method('textDocument/inlayHint')
    then
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

-- Markdown settings: fluid soft-wrapping without breaking URLs/punctuation
local markdownGroup =
  vim.api.nvim_create_augroup('MarkdownSettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = markdownGroup,
  pattern = { 'markdown', 'quarto' },
  desc = 'Configure soft-wrap, breakat, and link helpers for Markdown',
  callback = function(event)
    -- Only break lines on spaces, tabs, and hyphens (never split mid-URL or before punctuation)
    vim.opt_local.breakat = ' \t-'
    -- Disable hard textwidth wrap during insert mode so soft-wrap flows naturally
    vim.opt_local.textwidth = 0

    -- Buffer-local keymap to extract inline link to reference definition
    vim.keymap.set(
      'n',
      '<leader>lr',
      '<Cmd>MarkdownExtractRefLink<CR>',
      { buffer = event.buf, desc = 'Extract link to reference definition' }
    )
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

-- Extract inline Markdown link under cursor to reference link at buffer end
vim.api.nvim_create_user_command('MarkdownExtractRefLink', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
  if not line then
    return
  end

  local target_start, target_end, label, url
  local init = 1
  while true do
    local ms, me, ml, mu = line:find('%[([^%]]+)%]%(([^%)]+)%)', init)
    if not ms then
      break
    end
    if col >= (ms - 1) and col <= me then
      target_start, target_end, label, url = ms, me, ml, mu
      break
    end
    if not target_start then
      target_start, target_end, label, url = ms, me, ml, mu
    end
    init = me + 1
  end

  if not (target_start and label and url) then
    vim.notify(
      'No Markdown inline link found on the current line.',
      vim.log.levels.WARN
    )
    return
  end

  local clean_key = label:gsub('`', ''):gsub('^%s*(.-)%s*$', '%1')
  if clean_key:find('/') then
    clean_key = vim.fs.basename(clean_key)
  end

  vim.ui.input(
    { prompt = 'Reference key: ', default = clean_key },
    function(key)
      if not key or key:match('^%s*$') then
        return
      end

      local new_line = line:sub(1, target_start - 1)
        .. '['
        .. label
        .. ']['
        .. key
        .. ']'
        .. line:sub(target_end + 1)
      vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { new_line })

      local line_count = vim.api.nvim_buf_line_count(bufnr)
      local last_lines = vim.api.nvim_buf_get_lines(
        bufnr,
        math.max(0, line_count - 1),
        line_count,
        false
      )
      local ref_def = string.format('[%s]: %s', key, url)

      if #last_lines > 0 and last_lines[1] ~= '' then
        vim.api.nvim_buf_set_lines(
          bufnr,
          line_count,
          line_count,
          false,
          { '', ref_def }
        )
      else
        vim.api.nvim_buf_set_lines(
          bufnr,
          line_count,
          line_count,
          false,
          { ref_def }
        )
      end

      vim.notify(
        string.format('Extracted [%s] -> %s', key, url),
        vim.log.levels.INFO
      )
    end
  )
end, { desc = 'Extract Markdown inline link to reference definition' })
