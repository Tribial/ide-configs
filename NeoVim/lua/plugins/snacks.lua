return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- bigfile = { enabled = true },
    -- dashboard = { enabled = true },
    -- explorer = { enabled = true },
    -- indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
  keys = {
    { "<leader>p", nil, desc = "Language specific [P]ackages" },
    { "<leader>pd", nil, desc = ".NET" },
    { "<leader>pdra", "<cmd>DotnetUI project reference add<cr>", desc = "Add project reference" },
    { "<leader>pdrd", "<cmd>DotnetUI project reference remove<cr>", desc = "Remove project reference" },
    { "<leader>pdpa", "<cmd>DotnetUI project package add<cr>", desc = "Add nuget package" },
    { "<leader>pdpd", "<cmd>DotnetUI project package remove<cr>", desc = "Remove nuget package" },
    { "<leader>pdn", "<cmd>DotnetUI new_item<cr>", desc = "Add new item" },
    { "<leader>pdb", "<cmd>DotnetUI file bootstrap<cr>", desc = "Bootstrap current buffer" },
  },
}
