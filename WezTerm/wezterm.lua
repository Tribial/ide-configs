local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- plugins
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)
wezterm.on("modal.enter", function(name, window, pane)
	modal.set_right_status(window, name)
	modal.set_window_title(pane, name)
end)

wezterm.on("modal.exit", function(name, window, pane)
	window:set_right_status("NOT IN A MODE")
	modal.reset_window_title(pane)
end)

-- appearance
config.color_scheme = "One Half Black (Gogh)"
config.window_background_image = "C:/Users/fdomurad/OneDrive - Nest Bank S.A/Obrazy/nest_2.jpg"
config.window_background_image_hsb = {
	brightness = 0.01,
	saturation = 0.8,
}

-- shells
local launch_menu = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	local pwsh = { "pwsh.exe", "-NoLogo", "-NoExit", "-WorkingDirectory", "C:/repos" }
	config.default_prog = pwsh

	config.wsl_domains = {
		{
			name = "WSL:Debian",
			distribution = "Debian",
			default_cwd = "~",
		},
	}
	table.insert(launch_menu, {
		label = "PowerShell",
		args = pwsh,
	})
end

config.launch_menu = launch_menu

return config
