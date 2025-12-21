return {
  'm4xshen/hardtime.nvim',
  lazy = false,
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    excluded_keys = {
      -- Add other keys you want to exclude here
      ['<C-y>'] = true, -- Exclude Ctrl+y from hardtime's restrictions
      ['<C-n>'] = true, -- Exclude Ctrl+n if used for closing completion
      ['<C-p>'] = true, -- Exclude Ctrl+p if used for prev completion
      ['<C-e>'] = true, -- Exclude Ctrl+e if used for cancel completion
      ['<C-b>'] = true, -- Exclude Ctrl+b if used for scrolling docs up
      ['<C-f>'] = true, -- Exclude Ctrl+f if used for scrolling docs down
      -- Depending on your blink.cmp setup, you might need to exclude others like <CR> or <Tab>
      -- ['<CR>'] = true,
      -- ['<Tab>'] = true,
    },
  },
}
