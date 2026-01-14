return {
  'MeanderingProgrammer/treesitter-modules.nvim',
  config = function()
    require('treesitter-modules').setup {
      ensure_installed = {
        'r',
        'python',
        'rnoweb',
        'yaml',
        'csv',
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'matlab',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
      -- Autoinstall languages that are not installed
      indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>', -- start selection
          node_incremental = '<CR>', -- expand to next node
          scope_incremental = '<S-CR>', -- expand to next scope
          node_decremental = '<BS>', -- shrink selection
        },
      },
      auto_install = true,
      ignore_install = {},
      modules = {},
      highlight = { enable = true },

      textobjects = {},
    }
  end,
}
