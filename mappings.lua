---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<leader>e"] = "",
    ["<leader>b"] = "",
    ["<leader>n"] = "",
    ["<leader>x"] = "",
    -- TODO: Setup cheatsheet
    ["<leader>ch"] = "",
    ["<leader>ca"] = "",
    ["<leader>cm"] = "",
    ["<leader>cc"] = "",
    ["<leader>ff"] = "",
    ["<leader>fa"] = "",
    ["<leader>fw"] = "",
    ["<leader>fb"] = "",
    ["<leader>fh"] = "",
    ["<leader>fo"] = "",
    ["<leader>fz"] = "",
    -- TODO: Do I need the LSP format?
    ["<leader>fm"] = "",
  },
  v = {
    ["<leader>ca"] = "",
  },
}

M.abc = {
  n = {
    -- --------------------- General -----------------------
    ["<leader>e"] = { ":NvimTreeToggle<CR>", "Toggle explorer" },
    ["<leader>q"] = { ":nohl<CR>", "Clear highlight" },
    ["<leader>c"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },
    ["<A-o>"] = { "mzo<Esc>`z", "Empty line below" },
    ["<A-O>"] = { "mzO<Esc>`z", "Empty line above" },
    ["<A-;>"] = { "mzA;<Esc>`z", "Put semicolon" },
    ["<leader>tc"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
    ["<leader>n"] = {"<cmd> GlobalNote <CR>", "Show global note"},
    -- ----------------- Language Specific -----------------
    ["<leader>lf"] = {
      function()
        require("conform").format()
      end,
      "Format code",
    },
    ["<leader>ld"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },
    ["<leader>la"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },
    ["<leader>lc"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd [[normal! _]]
        end
      end,

      "Jump to current context",
    },
    ["<leader>lj"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "Next diagnostic",
    },
    ["<leader>lk"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "Previous diagnostic",
    },
    ["<leader>lr"] = {
      function()
         vim.lsp.buf.rename()
      end,
      "Rename"
    },
    -- -------------------- Search ------------------
    ["<leader>sf"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>sa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
    ["<leader>st"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>sb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>sh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
    ["<leader>so"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
    ["<leader>sz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },
    -- -------------------- Debug -------------------
    -- ["<leader>db"] = { "<cmd> call vimspector#ToggleBreakpoint() <CR>", "Toggle breakpoint" },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
  i = {
    ["<A-;>"] = { "<Esc>mzA;<esc>`z", "Put semicolon" },
  },
}

M.groups = {
  n = {
    -- ["<leader>"] = {
    -- l = { name = "LSP" },
    -- s = { name = "Search" },
    -- -- d = { name = "Debug" },
    -- -- b = { name = "Buffer" },
    -- g = { name = "Git" },
    -- m = { name = "NoName" },
    -- p = { name = "Plugins" },
    -- r = { name = "NoName2" },
    -- t = { name = "NoName3" },
    -- w = { name = "Workspace/WhichKey" },
    -- },
  },
  --   --   v= {}
}

return M
