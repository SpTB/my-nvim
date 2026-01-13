return {
  'vhyrro/luarocks.nvim',
  priority = 1000,
  config = true,
}, {
  'nvim-neorg/neorg',
  dependencies = { 'vhyrro/luarocks.nvim', 'nvim-treesitter/nvim-treesitter' },
  lazy = false,
  version = '*',
  config = function()
    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = { config = { icon_preset = 'varied' } },
        ['core.keybinds'] = {},
        ['core.dirman'] = {
          config = { workspaces = { notes = '~/notes' }, default_workspace = 'notes' },
        },
        ['core.integrations.treesitter'] = {
          config = { install_parsers = true },
        },
      },
    }

    -- (keep your keymaps/commands below unchanged)
  end,
}
