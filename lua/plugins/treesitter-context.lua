return {
  'nvim-treesitter/nvim-treesitter-context',
  enable = true,
  event = 'BufReadPost',
  config = function()
    require('treesitter-context').setup {
      --    enable = true,
      max_lines = 4, -- number of context lines to show
      multiline_threshold = 5,
      --    trim_scope = 'outer', -- which lines to remove if context too large
      --    mode = 'cursor', -- 'cursor' or 'topline'
      --    separator = 'nil', -- line below context
    }
  end,
}
