local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.default_cursor_style = "BlinkingBar"
config.color_scheme = "Tokyo Night"
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 16.5

-- Override background to darker shade (for tmux dimming effect)
config.colors = {
	background = "#0f0f14",
}

config.window_padding = {
	left = 3,
	right = 3,
	top = 0,
	bottom = 0,
}

config.set_environment_variables = {
	EDITOR = "nvim",
	VISUAL = "nvim",
}

return config
