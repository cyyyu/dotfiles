local wezterm = require 'wezterm'

return {
  color_scheme = 'Snazzy',
  enable_tab_bar = false,
  window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  },
  initial_cols = 100,
  initial_rows = 30,
  font = wezterm.font('JetBrains Mono'),
  font_size = 14,
}
