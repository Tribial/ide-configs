return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = '[G]it [S]tatus (Fugitive)' })
    vim.keymap.set('n', '<leader>gC', ':Git commit<CR>', { desc = '[G]it [C]ommit' })
    vim.keymap.set('n', '<leader>gn', function()
      local branch = vim.fn.input('New branch name: ')
      if branch ~= '' then
        vim.cmd('Git checkout -b ' .. branch)
      end
    end, { desc = '[G]it [N]ew branch' })
    vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = '[G]it [P]ush' })
    vim.keymap.set('n', '<leader>gP', function()
      local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('\n', '')
      vim.cmd('Git push --set-upstream origin ' .. branch)
    end, { desc = '[G]it [P]ush set upstream (shift+p)' })
    vim.keymap.set('n', '<leader>gl', ':Git pull<CR>', { desc = '[G]it Pul[l]' })
    vim.keymap.set('n', '<leader>gB', ':Git blame<CR>', { desc = '[G]it [B]lame (shift+b)' })
  end,
}
