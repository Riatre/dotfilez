local wezterm = require "wezterm";

local Jellybeans = {
    -- 0 #e8e8d3  -- Default Foreground
    -- 1 #e8e8ff  -- Default Foreground Bold
    -- 2 #121212  -- Default Background
    -- 3 #121212  -- Default Background Bold
    -- 4 #000000
    -- 5 #00ff00
    -- 6 #1c1c1c  -- ANSI Black
    -- 7 #404040  -- ANSI Black Bold
    -- 8 #b85335  -- ANSI Red
    -- 9 #cf6a4c  -- ...
    -- 10 #799d6a
    -- 11 #99ad6a
    -- 12 #ffb964
    -- 13 #fad07a
    -- 14 #667899
    -- 15 #8197bf
    -- 16 #8787af
    -- 17 #c6b6ee
    -- 18 #668799
    -- 19 #8fbfdc
    -- 20 #dddddd -- ANSI White
    -- 21 #e8e8d3 -- ANSI White Bold

    foreground = "#e8e8d3",
    background = "#121212",

    cursor_fg = "#000000",
    cursor_bg = "#00ff00",

    cursor_border = "#00ff00",

    ansi    = {"#1c1c1c", "#b85335", "#799d6a", "#ffb964", "#667899", "#8787af", "#668799", "#dddddd"},
    brights = {"#404040", "#cf6a4c", "#99ad6a", "#fad07a", "#8197bf", "#c6b6ee", "#8fbfdc", "#e8e8d3"},
}

local dim_by_fifteen_percent = {
    hue = 1.0,
    saturation = 1.0,
    brightness = 0.85,
}

local launch_menu = {}
local keys = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    table.insert(launch_menu, {
        label = "Powershell",
        args = {"powershell.exe", "-NoLogo"},
    })
    table.insert(launch_menu, {
        label = "WSL (Default)",
        args = {"wsl.exe"},
    })
end

if wezterm.target_triple == "aarch64-apple-darwin" then
  keys = {
    {
      key = ',',
      mods = 'SUPER',
      action = wezterm.action.SpawnCommandInNewTab {
        cwd = wezterm.home_dir,
        args = { '/opt/homebrew/bin/nvim', wezterm.config_file },
      },
    },
  }
end

config = {
    color_scheme = "Jellybeans",
    -- color_scheme = "Tomorrow Night Bright",
    -- foreground_text_hsb = dim_by_fifteen_percent, -- For use with Tomorrow Night Bright
    color_schemes = {["Jellybeans"] = Jellybeans},
    hide_tab_bar_if_only_one_tab = true,
    exit_behavior = "Close",
    font = wezterm.font_with_fallback({
        "Iosevka Term",
        "Noto Sans Mono CJK SC",
    }),
    font_size = 12.0,
    launch_menu = launch_menu,
    scrollback_lines = 50000,
    initial_cols = 240,
    initial_rows = 72,
    mouse_bindings = {
        {
            event={Up={streak=1, button="Right"}},
            mods="NONE",
            action=wezterm.action.PasteFrom "Clipboard",
        },
    },
    canonicalize_pasted_newlines = "None",
    ssh_backend = "LibSsh", 
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    front_end = "WebGpu",
    keys = keys,
}

if wezterm.target_triple == "aarch64-apple-darwin" then
    -- config.window_background_opacity = 0.9
    -- config.macos_window_background_blur = 30
    config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
    config.hide_tab_bar_if_only_one_tab = false
end

if wezterm.hostname() == "ookipad.local" then
    config.font_size = 15.0
end

return config
