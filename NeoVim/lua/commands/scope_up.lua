local ts_utils = require 'nvim-treesitter.ts_utils'

local function goto_parent_scope()
	local node = ts_utils.get_node_at_cursor()
	if not node then
		vim.notify('No treesitter node found', vim.log.levels.WARN)
		return
	end

	local t = node:type()
	print(t)
	local parent = node:parent()
	if not parent then
		vim.notify('No parent node found', vim.log.levels.WARN)
		return
	end

	local start_row, start_col = parent:start()
	vim.api.nvim_win_set_cursor(0, {start_row + 1, start_col})
end

vim.api.nvim_create_user_command("CstScopeUp", goto_parent_scope, {desc = 'Go to parent scope'})
