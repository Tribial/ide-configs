return {
  'navarasu/onedark.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('onedark').setup {
      styles = {
        comments = { italic = false }, -- Disable italics in comments
      },
      style = 'darker',
    }

    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    require('onedark').load()
    vim.cmd.colorscheme 'onedark'
    -- Black for main groups
    vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#000000' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#000000' })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#0f0f0f' })
    vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = '#000000', fg = '#000000' })

    -- Black for nvimtree
    vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = '#000000' })
    vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = '#000000' })
    vim.api.nvim_set_hl(0, 'NvimTreeStatusLine', { bg = '#000000' })
    vim.api.nvim_set_hl(0, 'NvimTreeStatusLineNC', { bg = '#000000' })

    vim.o.background = 'dark'
  end,
}
