--  See `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Filetype-specific indentation settings
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set indentation for Lua files',
  group = vim.api.nvim_create_augroup('lua-indent', { clear = true }),
  pattern = 'lua',
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set indentation for C# files',
  group = vim.api.nvim_create_augroup('csharp-indent', { clear = true }),
  pattern = 'cs',
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set indentation for TypeScript/React files',
  group = vim.api.nvim_create_augroup('typescript-indent', { clear = true }),
  pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  callback = function()
    vim.bo.expandtab = false  -- Use tabs
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 0
  end,
})

-- Prevent :wa from trying to save C# source-generated/decompiled files
vim.api.nvim_create_autocmd('BufRead', {
  desc = 'Mark C# source-generated files as non-writable',
  group = vim.api.nvim_create_augroup('csharp-generated-readonly', { clear = true }),
  pattern = '*',
  callback = function()
    local path = vim.fn.expand('%:p')
    local bufname = vim.api.nvim_buf_get_name(0)
    -- Match: /obj/ dirs, .g.cs files, .nuget packages, .dll files, or LSP source-generated URIs
    if path:match('/obj/')
        or path:match('%.g%.cs$')
        or path:match('%.nuget/')
        or path:match('%.dll')
        or bufname:match('assemblyVersion=') then
      vim.bo.buftype = 'nofile'
      vim.bo.modifiable = false
    end
  end,
})
