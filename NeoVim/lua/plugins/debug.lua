-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
local function find_cs_solution_root()
	local dir = vim.fn.expand('%:p:h')
	while dir ~= '/' do
		if vim.fn.glob(dir .. '/*.slnx') ~= '' or vim.fn.glob(dir .. '/*.sln') ~= '' then
			return dir
		end
		dir = vim.fn.fnamemodify(dir, ':h')
	end
	return nil
end

local function find_runnable_csprojs(root)
	local csprojs = {}
	local cmd = 'find ' .. root .. ' -name "*.csproj"'
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	for csproj in result:gmatch("[^\n]+") do
		local proj_dir = vim.fn.fnamemodify(csproj, ':h')
		if vim.fn.glob(proj_dir .. '/Program.cs') ~= '' then
			table.insert(csprojs, csproj)
		end
	end
	return csprojs
end

local function cs_select_and_build_project(callback)
	local root = find_cs_solution_root()
	if not root then
		vim.notify("No solution root found", vim.log.levels.ERROR)
		return
	end
	local csprojs = find_runnable_csprojs(root)
	if #csprojs == 0 then
		vim.notify("No runnable projects found", vim.log.levels.ERROR)
		return
	end
	vim.ui.select(csprojs, {prompt = 'Select project:'}, function(selected)
		if not selected then return end
		local build_cmd = 'dotnet build ' .. selected
		os.execute(build_cmd)
		callback(selected)
	end
	)
end

local function cs_get_dll_path(csproj)
	local base_dir = vim.fn.fnamemodify(csproj, ":h") .. "/bin/Debug/"
	local proj_name = vim.fn.fnamemodify(csproj, ":t:r")
	local net9_path = base_dir .."net9.0/" .. proj_name .. ".dll"
	if vim.fn.glob(net9_path) ~= '' then
		return net9_path
	end
	return base_dir .. "net8.0/" .. proj_name .. ".dll"
end


return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
	-- 'nicholasmata/nvim-dap-cs',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
	dap.adapters.coreclr = {
			type = "executable",
			command = "netcoredbg",
			args = { "--interpreter=vscode"},
		}
	dap.configurations.cs = {
			{
				type = "coreclr",
				name = "Launch .NET Project",
				request = "launch",
				program = function()
					local result
					local co = coroutine.running()
					cs_select_and_build_project(function(choice)
						result = cs_get_dll_path(choice)
						coroutine.resume(co, result)
					end)
					return coroutine.yield()
				end
			}
		}
  end,
}
