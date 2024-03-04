
local M = {}

M.override = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    -- "rust",
    "c_sharp",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

return M;
