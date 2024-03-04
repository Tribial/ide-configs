local M = {}

local mappings = {
  { key = { "l", "o" }, cb = "edit" },
  -- { key = "W", cb = tree_cb "exapnd_all" },
  -- { key = "E", cb = tree_cb "collapse_all" },
}

-- git support in nvimtree
M.override = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },

  -- view = {
  --   mappings = {
  --     list = mappings,
  --   },
  -- },
}

return M
