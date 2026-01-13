return {
  'nvim-neorg/neorg',
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = '*', -- Pin Neorg to the latest stable release
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('neorg').setup {
      load = {
        ['core.integrations.treesitter'] = {
          config = {
            install_parsers = false,
          },
        },
        ['core.defaults'] = {},
        ['core.concealer'] = {
          config = {
            icon_preset = 'varied',
          },
        },
        ['core.keybinds'] = {},
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/notes',
            },
            default_workspace = 'notes',
          },
        },
      },
    }

    -- open linked item
    vim.keymap.set('n', '<localleader>no', '<Plug>(neorg.esupports.hop.hop-link)', { silent = true })

    --demote node (recursively)
    --(not sure why the function is promote, naming in the module seems reversed)
    vim.keymap.set('n', '<localleader>dr', '<Plug>(neorg.promo.promote.nested)', { silent = true })
    --promote node (recursively)
    vim.keymap.set('n', '<localleader>pr', '<Plug>(neorg.promo.demote.nested)', { silent = true })
    -- same but non-recursive
    vim.keymap.set('n', '<localleader>dd', '<Plug>(neorg.promo.promote)', { silent = true })
    vim.keymap.set('n', '<localleader>pp', '<Plug>(neorg.promo.demote)', { silent = true })

    -- Custom command to extract tagged list items from a neorg file
    local function show_results_in_buffer(results, tag)
      if #results > 0 then
        -- Create a new buffer
        vim.cmd 'enew'
        -- Set the buffer name
        vim.api.nvim_buf_set_name(0, 'Tagged Items: ' .. tag)
        -- Set filetype for syntax highlighting if desired
        vim.bo.filetype = 'norg'
        -- Insert the results into the buffer
        vim.api.nvim_buf_set_lines(0, 0, -1, false, results)
        print('Found ' .. #results .. " items tagged with '" .. tag .. "'.")
      else
        print("No items found with tag '" .. tag .. "'.")
      end
    end

    vim.api.nvim_create_user_command('ExtractTaggedItems', function(opts)
      local tag = opts.fargs[1]
      local file_path = opts.fargs[2]
      if not tag or not file_path then
        print 'Usage: ExtractTaggedItems <tag> <file_path>'
        return
      end

      -- The tilde character (~) is not automatically expanded in Lua's io.open function.
      -- We need to manually expand it to the user's home directory.
      file_path = vim.fn.expand(file_path)

      local neorg_utils = require 'custom.neorg_utils'
      local results = neorg_utils.extract_tagged_list_items(file_path, tag)

      show_results_in_buffer(results, tag)
    end, {
      nargs = '*',
      complete = function(arg_lead, cmd_line, cursor_pos)
        if #vim.fn.split(cmd_line, ' ') == 2 then
          -- No completion for the tag
          return {}
        elseif #vim.fn.split(cmd_line, ' ') == 3 then
          -- Complete file paths
          return vim.fn.glob(arg_lead .. '*', true, true)
        end
        return {}
      end,
      desc = 'Extracts tagged list items from a neorg file. Usage: ExtractTaggedItems <tag> <file_path>',
    })

    -- Keybindings for extracting tagged items from neorg files
    vim.keymap.set('n', '<localleader>l!', function()
      vim.cmd('ExtractTaggedItems important ' .. vim.fn.expand '%')
    end, { desc = '[L]ist [!]important items in current file' })

    vim.keymap.set('n', '<localleader>l?', function()
      vim.cmd('ExtractTaggedItems ambiguous ' .. vim.fn.expand '%')
    end, { desc = '[L]ist [?]ambiguous items in current file' })

    vim.keymap.set('n', '<localleader>l ', function()
      vim.cmd('ExtractTaggedItems undone ' .. vim.fn.expand '%')
    end, { desc = '[L]ist [ ]undone items in current file' })

    vim.keymap.set('n', '<localleader>l+', function()
      vim.cmd('ExtractTaggedItems recurring ' .. vim.fn.expand '%')
    end, { desc = '[L]ist [+]recurring items in current file' })

    vim.keymap.set('n', '<localleader>l-', function()
      vim.cmd('ExtractTaggedItems pending ' .. vim.fn.expand '%')
    end, { desc = '[L]ist [-]pending items in current file' })

    vim.keymap.set('n', '<localleader>l_', function()
      vim.cmd('ExtractTaggedItems cancelled ' .. vim.fn.expand '%')
    end, { desc = '[L]ist [_]cancelled items in current file' })

    vim.keymap.set('n', '<localleader>lx', function()
      vim.cmd('ExtractTaggedItems done ' .. vim.fn.expand '%')
    end, { desc = '[L]ist [x]done items in current file' })

    vim.keymap.set('n', '<localleader>l=', function()
      vim.cmd('ExtractTaggedItems on hold ' .. vim.fn.expand '%')
    end, { desc = '[L]ist [=]on hold items in current file' })
  end,
}
