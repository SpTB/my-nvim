--[[ -- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- this is necessary because to reduce the lag when pressing esc. The lag is caused by the command above: since esc is also used for removing the search highlighting
vim.keymap.set('i', 'hh', '<Esc>')
vim.keymap.set('i', 'dd', '<Esc>')
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
-- flag indicating whether the user triggered movement
user_want_insert = false

-- mark movement keys
local function mark_nav()
  user_want_insert = true
  return '<C-w>' -- it gets completed by next key like h/j/k/l
end

vim.keymap.set('n', '<C-h>', function()
  user_want_insert = true
  vim.cmd 'wincmd h'
end)
vim.keymap.set('n', '<C-j>', function()
  user_want_insert = true
  vim.cmd 'wincmd j'
end)
vim.keymap.set('n', '<C-k>', function()
  user_want_insert = true
  vim.cmd 'wincmd k'
end)
vim.keymap.set('n', '<C-l>', function()
  user_want_insert = true
  vim.cmd 'wincmd l'
end)

-- --  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Leave terminal-mode quickly
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Terminal: exit to Normal' })
vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]], { desc = 'Terminal: exit to Normal (alt)' })

-- Navigate windows directly from terminal-mode
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { silent = true, desc = 'Terminal: move left' })
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { silent = true, desc = 'Terminal: move down' })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { silent = true, desc = 'Terminal: move up' })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { silent = true, desc = 'Terminal: move right' })

vim.keymap.set('n', '<space>st', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 5)
end)

-- Custom command to move cursor to the end of visual selection
vim.api.nvim_create_user_command('MoveToVisualEnd', function()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local furthest_pos = start_pos[2] > end_pos[2] and start_pos or end_pos

  vim.schedule(function()
    local line_content = vim.api.nvim_buf_get_lines(0, furthest_pos[2] - 1, furthest_pos[2], false)[1] or ''
    local max_col = math.max(0, #line_content - 1)
    local target_col = math.min(furthest_pos[3] - 1, max_col)
    vim.api.nvim_win_set_cursor(0, { furthest_pos[2], target_col })
  end)
end, {})

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
