-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
local function get_neovim_root()
	return vim.fn.getcwd()
end

local function read_file_without_bom(filepath)
	local file = io.open(filepath, "rb")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	-- Remove UTF-8 BOM if present (EF BB BF)
	if content:sub(1, 3) == "\239\187\191" then
		content = content:sub(4)
	end
	return content
end

local function find_all_csprojs(root)
	local csprojs = {}
	local cmd = 'find ' .. vim.fn.shellescape(root) .. ' -name "*.csproj" 2>/dev/null'
	local handle = io.popen(cmd)
	if not handle then
		return csprojs
	end
	local result = handle:read("*a")
	handle:close()
	for csproj in result:gmatch("[^\n]+") do
		table.insert(csprojs, csproj)
	end
	return csprojs
end

local function parse_launch_settings(csproj_path)
	local proj_dir = vim.fn.fnamemodify(csproj_path, ':h')
	local proj_name = vim.fn.fnamemodify(csproj_path, ':t:r')
	local launch_settings_path = proj_dir .. '/Properties/launchSettings.json'

	if vim.fn.filereadable(launch_settings_path) == 0 then
		return {}
	end

	local content = read_file_without_bom(launch_settings_path)
	if not content then
		return {}
	end

	local ok, json_data = pcall(vim.json.decode, content)
	if not ok or not json_data or not json_data.profiles then
		return {}
	end

	local profiles = {}
	for profile_name, profile_data in pairs(json_data.profiles) do
		-- Only include Project type profiles (not IIS Express, etc.)
		if profile_data.commandName == "Project" then
			local env_vars = {}
			if profile_data.environmentVariables then
				for key, value in pairs(profile_data.environmentVariables) do
					env_vars[key] = tostring(value)
				end
			end
			table.insert(profiles, {
				display_name = proj_name .. " - " .. profile_name,
				csproj = csproj_path,
				proj_name = proj_name,
				profile_name = profile_name,
				env = env_vars,
				args = profile_data.commandLineArgs or "",
			})
		end
	end
	return profiles
end

local function collect_all_launch_profiles()
	local root = get_neovim_root()
	local csprojs = find_all_csprojs(root)
	local all_profiles = {}

	for _, csproj in ipairs(csprojs) do
		local profiles = parse_launch_settings(csproj)
		for _, profile in ipairs(profiles) do
			table.insert(all_profiles, profile)
		end
	end

	-- Sort by display name for consistent ordering
	table.sort(all_profiles, function(a, b)
		return a.display_name < b.display_name
	end)

	return all_profiles
end

local function cs_get_dll_path(csproj)
	local base_dir = vim.fn.fnamemodify(csproj, ":h") .. "/bin/Debug/"
	local proj_name = vim.fn.fnamemodify(csproj, ":t:r")
	-- Check for common .NET versions in order of preference
	local versions = { "net9.0", "net8.0", "net7.0", "net6.0" }
	for _, version in ipairs(versions) do
		local path = base_dir .. version .. "/" .. proj_name .. ".dll"
		if vim.fn.filereadable(path) == 1 then
			return path
		end
	end
	-- Fallback to net8.0 (will be built if not exists)
	return base_dir .. "net8.0/" .. proj_name .. ".dll"
end

local function cs_select_profile_and_build(callback)
	local profiles = collect_all_launch_profiles()

	if #profiles == 0 then
		vim.notify("No launch profiles found in any launchSettings.json", vim.log.levels.ERROR)
		return
	end

	local display_names = {}
	for _, profile in ipairs(profiles) do
		table.insert(display_names, profile.display_name)
	end

	vim.ui.select(display_names, { prompt = 'Select launch profile:' }, function(selected, idx)
		if not selected or not idx then
			return
		end
		local profile = profiles[idx]
		local build_cmd = 'dotnet build --configuration Debug --verbosity quiet ' .. vim.fn.shellescape(profile.csproj)
		vim.notify("Building " .. profile.proj_name .. " (Debug)...", vim.log.levels.INFO)
		vim.fn.system(build_cmd)
		if vim.v.shell_error == 0 then
			vim.notify("Build successful", vim.log.levels.INFO)
		else
			vim.notify("Build failed (run 'dotnet build' manually to see errors)", vim.log.levels.ERROR)
		end
		callback(profile)
	end)
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
    {
      '<leader>dl',
      function()
        require('dapui').eval()
      end,
      mode = { 'n', 'v' },
      desc = 'Debug: Floating inspection',
    },
    {
      '<leader>dw',
      function()
        require('dapui').elements.watches.add()
      end,
      mode = { 'n', 'v' },
      desc = 'Debug: Add to watch',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.toggle()
      end,
      desc = 'Debug: Toggle REPL',
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
      layouts = {
        {
          -- Left sidebar: scopes and breakpoints
          elements = {
            { id = "scopes", size = 0.6 },
            { id = "breakpoints", size = 0.2 },
            { id = "stacks", size = 0.2 },
          },
          size = 40,
          position = "left",
        },
        {
          -- Bottom panel: repl only (no console)
          elements = {
            { id = "repl", size = 1.0 },
          },
          size = 0.3,
          position = "bottom",
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
	-- Store selected profile for current debug session
	local current_debug_profile = nil

	local function select_profile_once()
		if current_debug_profile then
			return current_debug_profile
		end
		local co = coroutine.running()
		cs_select_profile_and_build(function(profile)
			current_debug_profile = profile
			coroutine.resume(co, profile)
		end)
		return coroutine.yield()
	end

	-- Clear profile when debug session ends
	dap.listeners.before.event_terminated['clear_profile'] = function()
		current_debug_profile = nil
	end
	dap.listeners.before.event_exited['clear_profile'] = function()
		current_debug_profile = nil
	end

	dap.configurations.cs = {
			{
				type = "coreclr",
				name = "Launch .NET Project (from launchSettings.json)",
				request = "launch",
				justMyCode = true,
				program = function()
					local profile = select_profile_once()
					return cs_get_dll_path(profile.csproj)
				end,
				env = function()
					local profile = select_profile_once()
					if profile and profile.env then
						return profile.env
					end
					return {}
				end,
				args = function()
					local profile = select_profile_once()
					if profile and profile.args and profile.args ~= "" then
						-- Split args string into table for DAP
						local args_table = {}
						for arg in profile.args:gmatch("%S+") do
							table.insert(args_table, arg)
						end
						return args_table
					end
					return {}
				end,
				cwd = function()
					local profile = select_profile_once()
					if profile then
						return vim.fn.fnamemodify(profile.csproj, ":h")
					end
					return vim.fn.getcwd()
				end,
			}
		}
  end,
}
