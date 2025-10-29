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

function update_overrides_if_changed(window, new_config)
    local overrides = window:get_config_overrides() or {}
    local diff = false
    for k, v in pairs(new_config) do
        if overrides[k] ~= v then
            diff = true
            overrides[k] = v
        end
    end
    if diff then
        window:set_config_overrides(overrides)
    end
end

local keys = {}

if wezterm.target_triple == "aarch64-apple-darwin" then
    table.insert(keys, {
        key = ',',
        mods = 'SUPER',
        action = wezterm.action.SpawnCommandInNewTab {
          cwd = wezterm.home_dir,
          args = { '/opt/homebrew/bin/nvim', wezterm.config_file },
        },
    })
    table.insert(keys, {
        key = 'p',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.DisableDefaultAssignment,
    })
    table.insert(keys, {
        key = 'p',
        mods = 'SUPER|SHIFT',
        action = wezterm.action.ActivateCommandPalette,
    })
    table.insert(keys, {
      key = 'phys:Help',
      action = wezterm.action.SendKey { key="Insert" },
    })
    table.insert(keys, {
        key = 'phys:Help',
        mods = 'SHIFT',
        action = wezterm.action.PasteFrom 'Clipboard',
    })
end

config = {
    color_scheme = "Jellybeans",
    -- color_scheme = "Tomorrow Night Bright",
    -- foreground_text_hsb = dim_by_fifteen_percent, -- For use with Tomorrow Night Bright
    color_schemes = {["Jellybeans"] = Jellybeans},
    exit_behavior = "Close",
    font = wezterm.font_with_fallback({
        "Iosevka Term",
        "Noto Sans Mono CJK SC",
    }),
    font_size = 12.0,
    launch_menu = {},
    scrollback_lines = 50000,
    initial_cols = 240,
    initial_rows = 72,
    mouse_bindings = {
        {
            event={Up={streak=1, button="Right"}},
            mods="NONE",
            action=wezterm.action.PasteFrom "Clipboard",
        },
        {
            event={Up={streak=1, button="Left"}},
            mods="NONE",
            action=wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
        },
        {
            event={Up={streak=1, button="Left"}},
            mods="SHIFT",
            action=wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
        },
        {
            event={Up={streak=1, button="Left"}},
            mods="SHIFT|ALT",
            action=wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
        },
        {
            event={Up={streak=1, button="Left"}},
            mods="CTRL",
            action=wezterm.action.OpenLinkAtMouseCursor,
        },
        {
            event={Up={streak=1, button="Left"}},
            mods="SUPER",
            action=wezterm.action.OpenLinkAtMouseCursor,
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
    selection_word_boundary = " \t\n{}[]()\"'`│",
    ssh_domains = wezterm.default_ssh_domains(),
    window_decorations = "INTEGRATED_BUTTONS|RESIZE",
    max_fps = 120,
    command_palette_font_size = 16,
    command_palette_rows = 15,
}

if wezterm.hostname() == "ookipad.local" or wezterm.hostname() == "mookipad.local" then
    config.font_size = 15.0
    config.max_fps = 60
end

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    table.insert(config.launch_menu, {
        label = "Powershell",
        args = {"powershell.exe", "-NoLogo"},
    })
    table.insert(config.launch_menu, {
        label = "WSL (Default)",
        args = {"wsl.exe"},
    })

    for _, domain in ipairs(config.ssh_domains) do
        domain.ssh_option = {
            identityagent = 'C:\\Users\\Riatre\\.ssh\\af_unix_auth_sock',
        }
    end
    config.window_frame =  {
        font = wezterm.font "Noto Mono",
        
    }
    config.window_padding.top = 3
end

-- Hide window decoration when full screen and only one tab.
wezterm.on("window-resized", function(window, pane)
    local new_config
    if window:get_dimensions().is_full_screen then
        new_config = {
            window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
            hide_tab_bar_if_only_one_tab = true,
            window_decorations = "RESIZE",
            use_fancy_tab_bar = false,
        }
    else
        new_config = {
            window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
            hide_tab_bar_if_only_one_tab = false,
            window_decorations = "INTEGRATED_BUTTONS|RESIZE",
            use_fancy_tab_bar = true,
        }
        if wezterm.target_triple == "x86_64-pc-windows-msvc" then
            new_config.window_padding.top = 3
        end
    end
    update_overrides_if_changed(window, new_config)
end)

return config
