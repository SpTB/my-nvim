return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'master',
    dependencies = { 'nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {}, -- or e.g. { "lua", "python", "r", "matlab" }
        sync_install = true,
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

        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            --if you want to be less specific, you can also use goto_next, and goto_previous, which first goes to start and then end
            goto_next_start = {
              [']f'] = '@function.outer',
              [']i'] = '@conditional.outer',
              [']l'] = '@loop.outer',
              -- [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[i'] = '@conditional.outer',
              ['[l'] = '@loop.outer',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
              [']I'] = '@conditional.outer',
              [']L'] = '@loop.outer',
              -- [']['] = '@class.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
              ['[I'] = '@conditional.outer',
              ['[L'] = '@loop.outer',
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['ai'] = '@conditional.outer',
              ['ii'] = '@conditional.outer',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.outer',
              ['at'] = '@comment.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
    end,
  },
}
