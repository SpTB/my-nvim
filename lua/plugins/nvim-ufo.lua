return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    require('ufo').setup {
      provider_selector = function(bufnr, filetype, buftype)
        return { 'lsp', 'indent' }
      end,
    }
  end,
}
-- return {
--   'numToStr/Comment.nvim',
--   config = function()
--     require('Comment').setup {
--       toggler = {
--         line = '<leader>cc',
--         block = 'gbc',
--       },
--     }
--   end,
-- }
