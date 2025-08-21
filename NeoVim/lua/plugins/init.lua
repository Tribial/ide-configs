local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

local treesitter_ensure_installed = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
}

local conform_formatters_by_ft = {
  lua = { 'stylua' },
  json = { 'prettier' },
  javascript = { 'prettier' },
  typescript = { 'prettier' },
  typescriptreact = { 'prettier' },
  javascriptreact = { 'prettier' },
  tf = { 'terraform_fmt' },
  tfvars = { 'terraform_fmt' },
}

local lsp_servers = {
  -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
  ts_ls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },
  prettier = {},
  terraformls = {},
  azure_pipelines_ls = {},
  tflint = {},
  bashls = {},
  -- roslyn = {},
}

local lsp_other = {
  'stylua', -- Used to format Lua code
}

require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    lazy = false,
    config = true,
    -- dependencies = 'hrsh7th/nvim-cmp',
    -- config = function()
    --   local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    --   local cmp = require 'cmp'
    --   cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    -- end,
  },
  {
    'ojroques/nvim-bufdel',
    lazy = false,
    config = function()
      vim.keymap.set('n', '<leader>bq', ':BufDel<CR>', { desc = '[B]uffer [q]uit' })
      vim.keymap.set('n', '<leader>bw', ':BufDelAll<CR>', { desc = '[B]uffer quit all' })
      require('bufdel').setup {
        next = 'tabs',
        quit = true,
      }
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {}
      vim.opt.termguicolors = true
      vim.keymap.set('n', '<S-j>', ':BufferLineCyclePrev<CR>', { desc = 'Buffer previous' })
      vim.keymap.set('n', '<S-k>', ':BufferLineCycleNext<CR>', { desc = 'Buffer next' })
    end,
  },
  {
    'unblevable/quick-scope',
    config = function()
      vim.api.nvim_set_hl(0, 'QuickScopePrimary', { fg = '#39ff14', bold = true, underline = true })
      vim.api.nvim_set_hl(0, 'QuickScopeSecondary', { fg = '#137b00', bold = false, underline = true })
    end,
  },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  require 'plugins.nvimtree',
  require 'plugins.whichkey',
  require 'plugins.telescope',
  -- ============================= LSP Plugins =============================
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  require 'plugins.dashboard',
  require 'plugins.lspconfig'(lsp_servers, lsp_other),
  require 'plugins.conform'(conform_formatters_by_ft),
  require 'plugins.cmp',
  -- ============================= LSP Plugins =============================
  -- require 'plugins.blinkcmp', neovim.cmp somehow is working better
  require 'plugins.theme',
  require 'plugins.mini',
  require 'plugins.treesitter'(treesitter_ensure_installed),
  require 'plugins.lint',
  -- TODO: Reevaluate what's usefull, apply it, remove rest
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require "kickstart.plugins.neo-tree",
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
