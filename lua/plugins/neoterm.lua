-- lua/plugins/neoterm.lu-- lua/plugins/neoterm.lua
return {
  'kassio/neoterm',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- --- neoterm basics
    vim.g.neoterm_default_mod = 'botright' -- open terminal at bottom/right
    vim.g.neoterm_size = 14 -- split height
    vim.g.neoterm_autoscroll = 1 -- keep output scrolled to bottom

    -- make sure truecolor is on
    vim.opt.termguicolors = true

    -- define the terminal bg you want
    vim.api.nvim_set_hl(0, 'NeoTermBg', { bg = '#1e1e1e' })

    -- keep it after colorscheme changes
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.api.nvim_set_hl(0, 'NeoTermBg', { bg = '#1e1e1e' })
      end,
    }) -- apply to all terminal windows (including neoterm)

    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = 'term://*',
      callback = function()
        local w = vim.wo
        if w.winhl ~= '' then
          w.winhl = w.winhl .. ',Normal:NeoTermBg'
        else
          w.winhl = 'Normal:NeoTermBg'
        end
      end,
    })

    --swith to insert mode when manually entering terminal
    vim.api.nvim_create_autocmd('WinEnter', {
      callback = function()
        if user_want_insert and vim.bo.buftype == 'terminal' then
          vim.cmd 'startinsert'
        end
        -- reset the flag no matter what
        user_want_insert = false
      end,
    })

    -- Tell neoterm which REPL to spawn for MATLAB buffers when using TREPLSend*
    -- (neoterm will start this automatically the first time you send code)
    vim.g.neoterm_repl_matlab = 'matlab -nodesktop -nosplash'

    -- Helper: start (or reuse) a MATLAB REPL on demand
    local function ensure_matlab_repl()
      -- If no terminal exists yet, :T will start one and run the command
      vim.cmd 'T matlab -nodesktop -nosplash'
      vim.cmd 'Topen' -- show it if hidden
    end

    -- Filetype-local keymaps for MATLAB buffers
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'matlab',
      callback = function(args)
        local buf = args.buf
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end

        -- Send current line to MATLAB REPL without a trailing ';'
        local function send_line_without_trailing_semicolon()
          local buf = vim.api.nvim_get_current_buf()
          local row = vim.api.nvim_win_get_cursor(0)[1] -- 1-based row

          -- get the current line
          local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
          if not line or line == '' then
            return
          end

          -- remove only a trailing semicolon (and optional spaces)
          local stripped = line:gsub('%s*;%s*$', '')

          -- if nothing changed, just use the normal send-line mapping
          if stripped == line then
            vim.cmd 'TREPLSendLine'
            return
          end

          -- temporarily replace the line with the stripped version
          vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { stripped })

          -- send that line via neoterm
          vim.cmd 'TREPLSendLine'

          -- restore original line
          vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { line })
        end
        -- Send visual selection, but strip trailing semicolon only from LAST line

        map('n', '<leader>m;', send_line_without_trailing_semicolon, 'MATLAB: send line (no ;)')

        -- Start/attach to a MATLAB REPL (useful if you want to pre-open it)
        map('n', '<leader>mt', ensure_matlab_repl, 'MATLAB: start/attach REPL')

        -- Open/close the neoterm window (doesn't kill the process)
        map('n', '<leader>mo', ':Topen<CR>', 'MATLAB: open REPL window')
        map('n', '<leader>mq', ':Tclose<CR>', 'MATLAB: hide REPL window')

        -- Send the current line / visual selection / whole file to the MATLAB REPL
        -- These spawn the REPL automatically using g:neoterm_repl_matlab if needed.
        map('n', '<leader>mm', ':TREPLSendLine<CR>', 'MATLAB: send line')

        map('x', '<leader>ms', ':TREPLSendSelection<CR>:MoveToVisualEnd<CR>', 'MATLAB: send selection')
        map('n', '<leader>mr', ':TREPLSendFile<CR>', 'MATLAB: run current file')

        -- Clear terminal output
        map('n', '<leader>mc', ':Tclear<CR>', 'MATLAB: clear REPL buffer')

        -- Optional: quick ‘cd’ the REPL into this file’s folder then run the file
        map('n', '<leader>mR', function()
          local dir = vim.fn.expand '%:p:h'
          local file = vim.fn.expand '%:p'
          vim.cmd 'Topen'
          vim.cmd('T cd ' .. vim.fn.fnameescape(dir))
          vim.cmd 'w' -- save before run
          -- run("full/path/to/file.m")
          vim.cmd('T run("' .. file:gsub('\\', '\\\\'):gsub('"', '\\"') .. '")')
        end, 'MATLAB: cd to file dir & run')

        -- Helper: feed key sequences so we can reuse the visual <leader>ms mapping
        local function feed(keys)
          local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
          -- 'm' means "remap", so <leader>ms will go through your existing visual mapping
          vim.api.nvim_feedkeys(termcodes, 'm', false)
        end
        -- <leader>mw: select a word (v + w) and execute:w
        map('n', '<leader>mw', function()
          feed 'viw<leader>ms'
        end, 'MATLAB: send word')

        -- <leader>mW: select a Word (v + W) and execute
        map('n', '<leader>mW', function()
          feed 'viW<leader>ms'
        end, 'MATLAB: send WORD')

        -- <leader>mw: select a word (v + w) and execute:w
        map('n', '<leader>m$', function()
          feed 'v$<leader>ms'
        end, 'MATLAB: send until end of line')

        -- <leader>mi: select a conditional (vai motion) and execute
        -- assumes the 'ai' textobject for conditionals already exists
        map('n', '<leader>mi', function()
          feed 'vai<leader>ms'
        end, 'MATLAB: send conditional')

        -- <leader>mL: select a loop (val motion) and execute
        -- assumes the 'al' textobject for loops already exists
        map('n', '<leader>ml', function()
          feed 'val<leader>ms'
        end, 'MATLAB: send loop')

        -- <leader>mp: select a paragraph (vip motion) and execute
        map('n', '<leader>mp', function()
          feed 'vip<leader>ms'
        end, 'MATLAB: send paragraph')
      end,
    })
  end,
}
