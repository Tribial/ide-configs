local mason = require "custom.configs.overrides.mason"
local treesitter = require "custom.configs.overrides.treesitter"
local nvimtree = require "custom.configs.overrides.nvimtree"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = mason.override,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = treesitter.override,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = nvimtree.override,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  { 'unblevable/quick-scope',  Lazy = false },

  {
    "stevearc/conform.nvim",
    --  for users those who want auto-save conform + lazyloading!
    -- event = "BufWritePre"
    config = function()
      require "custom.configs.conform"
    end,
  },

  {
    "navarasu/onedark.nvim",
    lazy = false,
    config = function()
      require("onedark").setup {
        style = "darker",
      }
    end,
  },
  -- {
  --   "mrcjkb/rustaceanvim",
  --   version = "^4", -- Recommended
  --   ft = { "rust" },
  -- },
  {
    "puremourning/vimspector",
    lazy = false,
  },
  {
    "backdround/global-note.nvim",
    lazy = false,
    config = function()
      require("global-note").setup {}
    end,
  },
  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
