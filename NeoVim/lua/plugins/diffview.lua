return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local actions = require('diffview.actions')
    require('diffview').setup {
      keymaps = {
        view = {
          { 'n', '<Esc>', ':DiffviewClose<CR>', { desc = 'Close diffview' } },
        },
        file_panel = {
          { 'n', '<Esc>', ':DiffviewClose<CR>', { desc = 'Close diffview' } },
        },
        file_history_panel = {
          { 'n', '<Esc>', ':DiffviewClose<CR>', { desc = 'Close diffview' } },
        },
      },
    }
    vim.keymap.set('n', '<leader>gc', ':DiffviewOpen<CR>', { desc = '[G]it [C]ompare (Diffview)' })
    vim.keymap.set('n', '<leader>gd', ':DiffviewFileHistory %<CR>', { desc = '[G]it [D]iff current file' })
  end,
}
