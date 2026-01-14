return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require('nvim-treesitter-textobjects').setup {
        move = {
          enable = true,
          set_jumps = true,

          --goto next start
          vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
          end),
          vim.keymap.set({ 'n', 'x', 'o' }, ']i', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@conditional.outer', 'textobjects')
          end),
          vim.keymap.set({ 'n', 'x', 'o' }, ']l', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@loop.outer', 'textobjects')
          end),

          --goto previous start
          vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
            require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
          end),
          vim.keymap.set({ 'n', 'x', 'o' }, '[i', function()
            require('nvim-treesitter-textobjects.move').goto_previous_start('@conditional.outer', 'textobjects')
          end),
          vim.keymap.set({ 'n', 'x', 'o' }, '[l', function()
            require('nvim-treesitter-textobjects.move').goto_previous_start('@loop.outer', 'textobjects')
          end),

          --goto next end
          vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
            require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
          end),
          vim.keymap.set({ 'n', 'x', 'o' }, ']I', function()
            require('nvim-treesitter-textobjects.move').goto_next_end('@conditional.outer', 'textobjects')
          end),
          vim.keymap.set({ 'n', 'x', 'o' }, ']L', function()
            require('nvim-treesitter-textobjects.move').goto_next_end('@loop.outer', 'textobjects')
          end),

          --goto previous end
          vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
            require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
          end),
          vim.keymap.set({ 'n', 'x', 'o' }, '[I', function()
            require('nvim-treesitter-textobjects.move').goto_previous_end('@conditional.outer', 'textobjects')
          end),
          vim.keymap.set({ 'n', 'x', 'o' }, '[L', function()
            require('nvim-treesitter-textobjects.move').goto_previous_end('@loop.outer', 'textobjects')
          end),
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
      }

      --goto
      -- local goto_next_start = require('nvim-treesitter-textobjects.goto_next_start').goto_next_start

      --selecting
      local select = require('nvim-treesitter-textobjects.select').select_textobject
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        select('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        select('@function.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'al', function()
        select('@loop.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'il', function()
        select('@loop.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ai', function()
        select('@conditional.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ii', function()
        select('@conditional.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        select('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        select('@class.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'at', function()
        select('@comment.outer', 'textobjects')
      end)

      -- swapping
      local swap_next = require('nvim-treesitter-textobjects.swap').swap_next
      local swap_previous = require('nvim-treesitter-textobjects.swap').swap_previous
      vim.keymap.set({ 'x', 'o' }, '<leader>a', function()
        swap_next('@parameter.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, '<leader>A', function()
        swap_previous('@parameter.inner', 'textobjects')
      end)
    end,
  },
  -- place them in the correct locations.
}
