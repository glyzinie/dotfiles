local wezterm = require 'wezterm';

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = wezterm.truncate_right(utils.basename(tab.active_pane.foreground_process_name), max_width)
	if title == "" then
		title = wezterm.truncate_right(
			utils.basename(utils.convert_home_dir(tab.active_pane.current_working_dir)),
			max_width
		)
	end
	return {
		{ Text = tab.tab_index + 1 .. ":" .. title },
	}
end)

return {
	default_prog = {"/bin/zsh", "--login"},
	window_background_opacity = 0.85,
	--font = wezterm.font_with_fallback({
	--	{family = "UDEV Gothic 35JPDOC"},
	--	{family = "UDEV Gothic 35NFLG", assume_emoji_presentation = true},
	--}),
	use_ime = true,
	font_size = 12.0,
	color_scheme = "Tokyo Night",
	hide_tab_bar_if_only_one_tab = true,
	-- フォントサイズ変更時にウィンドウサイズも変更されないようにする
	adjust_window_size_when_changing_font_size = false,
}
