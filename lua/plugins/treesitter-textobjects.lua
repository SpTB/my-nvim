return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      -- Textobjects (main): define keymaps using the plugin’s modules.
      -- If any require fails, we just no-op (lets you boot cleanly).
      local ok_move, move = pcall(require, 'nvim-treesitter.textobjects.move')
      local ok_select, select = pcall(require, 'nvim-treesitter.textobjects.select')
      local ok_swap, swap = pcall(require, 'nvim-treesitter.textobjects.swap')

      -- MOVE
      if ok_move then
        move.setup {
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']i'] = '@conditional.outer',
            [']l'] = '@loop.outer',
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
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[I'] = '@conditional.outer',
            ['[L'] = '@loop.outer',
          },
        }
      end

      -- SELECT
      if ok_select then
        select.setup {
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
        }
      end

      -- SWAP
      if ok_swap then
        swap.setup {
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        }
      end
    end,
  },
}
