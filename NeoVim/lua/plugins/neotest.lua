return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
	-- test adapters
    "nsidorenco/neotest-vstest"
  },
  config = function()
	require("neotest").setup({
	  adapters = {
		require("neotest-vstest") {
			  dap_settings = {
				type = "coreclr",
			}
		}
	  },
	})

	vim.keymap.set('n', '<leader>ts', function() require('neotest').run.run() end, {desc = 'Nearest [T]est [S]tart'})
	vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand("%")) end, {desc = '[T]est [F]ile'})
	vim.keymap.set('n', '<leader>td', function() require('neotest').run.run({strategy = "dap"}) end, {desc = '[T]est [D]ebug'})
	vim.keymap.set('n', '<leader>tx', function() require('neotest').run.stop() end, {desc = '[T]est e[x]it'})
	vim.keymap.set('n', '<leader>tp', function() require("neotest").output.open({ enter = false, border = "rounded" }) end, {desc = '[T]est [P]eek'})
	vim.keymap.set('n', '<leader>tP', function() require("neotest").output_panel.open() end, {desc = '[T]est [P]eek window'})
	vim.keymap.set('n', '<leader>to', function() require("neotest").summary.open() end, {desc = '[T]est [O]pen summary'})
  end
}
