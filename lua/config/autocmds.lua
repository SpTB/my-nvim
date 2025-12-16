-- e.g. in lua/config/autocmds.lua (loaded at startup)
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
--
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Start INSERT only for truly empty, editable file buffers (not plugin UIs)
--local grp = vim.api.nvim_create_augroup('StartInsertOnEmptyEditable', { clear = true })

--vim.api.nvim_create_autocmd('BufEnter', {
--group = grp,
--callback = function(args)
--  local bufnr = args.buf
--  local bo = vim.bo[bufnr]

--  -- Skip non-file and special buffers (help, mason, qf, terminals, etc.)
--  if bo.buftype ~= '' then
--    return
--  end
--  -- Only if you can actually edit it
--  if not bo.modifiable or bo.readonly then
--    return
--  end
--  -- Optional: skip unnamed scratch buffers if you only want files
--  -- local name = vim.api.nvim_buf_get_name(bufnr)
--  -- if name == '' then return end

--  -- Truly empty buffer?
--  if vim.api.nvim_buf_line_count(bufnr) == 1 then
--    local l1 = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
--    if l1 == '' then
--      vim.cmd 'startinsert'
--    end
--  end
--end,
--})

--start insert alt implemntation: only on files started from vim with :e command
vim.api.nvim_create_autocmd('BufNewFile', {
  group = grp,
  callback = function(args)
    local bo = vim.bo[args.buf]
    if bo.buftype ~= '' or not bo.modifiable or bo.readonly then
      return
    end
    vim.cmd 'startinsert'
  end,
})
-- Auto-start r_language_server if not already attached
--vim.api.nvim_create_autocmd('FileType', {
--  pattern = { 'r', 'rmd', 'rnoweb', 'quarto' },
--callback = function(args)
-- Neovim ≥0.10: vim.lsp.get_clients; older: fallback to get_active_clients
--    local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
--
--    local attached = false
--    for _, c in pairs(get_clients { bufnr = args.buf }) do
--      if c.name == 'r_language_server' then
--        attached = true
--        break
--      end
--    end
--
--    if not attached then
--vim.cmd 'LspStart r_language_server'
--    end
--end,
--})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd 'normal! zz'
      end)
    end
  end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  command = 'wincmd L',
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('no_auto_comment', {}),
  callback = function()
    vim.opt_local.formatoptions:remove { 'c', 'r', 'o' }
  end,
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('dotenv_ft', { clear = true }),
  pattern = { '.env', '.env.*' },
  callback = function()
    vim.bo.filetype = 'dosini'
  end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd('CursorMoved', {
  group = vim.api.nvim_create_augroup('LspReferenceHighlight', { clear = true }),
  desc = 'Highlight references under cursor',
  callback = function()
    -- Only run if the cursor is not in insert mode
    if vim.fn.mode() ~= 'i' then
      local clients = vim.lsp.get_clients { bufnr = 0 }
      local supports_highlight = false
      for _, client in ipairs(clients) do
        if client.server_capabilities.documentHighlightProvider then
          supports_highlight = true
          break -- Found a supporting client, no need to check others
        end
      end

      -- 3. Proceed only if an LSP is active AND supports the feature
      if supports_highlight then
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end
    end
  end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd('CursorMovedI', {
  group = 'LspReferenceHighlight',
  desc = 'Clear highlights when entering insert mode',
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

-- shortcut fof listing LSP clients (kinda irrelevant given LspInfo...)
--vim.api.nvim_create_user_command('LspClients', function(opts)
--local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
--local bufnr = (opts.bang and 0) or 0 -- always current buffer
--local out = vim.inspect(get_clients { bufnr = bufnr })
-- pretty popup without requiring extra plugins
--vim.notify(out, vim.log.levels.INFO, { title = 'LSP clients (buf ' .. bufnr .. ')' })
--end, { bang = true })

-- open word docs
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.docx',
  callback = function()
    vim.cmd '%!pandoc -f docx -t markdown'
    vim.bo.filetype = 'markdown'
    vim.cmd 'silent filetype detect'
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '.docx',
  callback = function()
    vim.cmd ':%!pandoc -f markdown -t docx'
  end,
})
