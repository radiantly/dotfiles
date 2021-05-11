-- Conky, a system monitor https://github.com/brndnmtthws/conky
--
-- This configuration file is Lua code. You can write code in here, and it will
-- execute when Conky loads. You can use it to generate your own advanced
-- configurations.
--
-- Try this (remove the `--`):
--
--   print("Loading Conky config")
--
-- For more on Lua, see:
-- https://www.lua.org/pil/contents.html

conky.config = {
    alignment = 'bottom_right',
    border_width = 0,
    default_color = '#e2cdcd',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = false,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'monospace:size=14',
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    own_window = true,
    own_window_class = 'Conky',
    own_window_transparent = true,
    own_window_type = 'desktop',
    show_graph_range = false,
    show_graph_scale = false,
    use_spacer = 'none',
    use_xft = true,
}

conky.text = [[${offset 25}${exec cal}]]

-- vim: ft=lua
