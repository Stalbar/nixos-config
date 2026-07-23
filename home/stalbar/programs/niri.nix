{
  config,
  pkgs,
  nord,
  ...
}:
let
  hex = name: "${nord.${name}}";
  configKdl = ''
    // Generated niri config. Wiki: https://niri-wm.github.io/niri/

    // ── Input ──────────────────────────────────────────────
    input {
        keyboard {
            xkb {
                layout "${"us,ru"}"
                options "${"grp:win_space_toggle"}"
            }
        }
        touchpad {
            tap
            natural-scroll
            dwt
        }
        mouse {
            accel-speed 0.0
            accel-profile "flat"
        }
        focus-follows-mouse max-scroll-amount="0%"
    }

    // ── Outputs ────────────────────────────────────────────
    output "eDP-1" {
        mode "1920x1080@120.03"
        scale 1.0
    }
    output "HDMI-A-1" {
        mode "2560x1440@59.95"
        scale 1.25
    }

    // ── Startup ────────────────────────────────────────────
    spawn-at-startup "switch-theme" "--apply-current"
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "blueman-applet"
    spawn-at-startup "awww-daemon"

    // ── Layout ─────────────────────────────────────────────
    layout {
        gaps 10
        center-focused-column "never"
        default-column-width { proportion 0.5; }

        focus-ring {
            off
        }

    border {
        width 2
        // active-color "#${hex "nord15"}ee"
        inactive-color "#${hex "nord0"}55"

        // Gradient border: purple → blue at 45°
        active-gradient from="#${hex "nord15"}ee" to="#${hex "nord10"}cc" angle=45
    }

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        struts {
            right 44
        }
    }

    // ── Animations ─────────────────────────────────────────
    animations {
        off
    }

    // ── Misc ───────────────────────────────────────────────
    hotkey-overlay {
        skip-at-startup
    }
    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // ── Window Rules ───────────────────────────────────────
    window-rule {
        match app-id=r#"^((org\.pulseaudio\.pavucontrol|pavucontrol)(\.wrapped|-wrapped)?)$"#
        open-floating true
        default-column-width { proportion 0.5; }
        default-window-height { proportion 0.5; }
        geometry-corner-radius 12
        clip-to-geometry true
    }

    window-rule {
        match app-id=r#"^((blueman-manager|org\.blueman\.Manager)(\.wrapped|-wrapped)?)$"#
        open-floating true
        default-column-width { proportion 0.55; }
        default-window-height { proportion 0.6; }
        geometry-corner-radius 12
        clip-to-geometry true
    }

    window-rule {
        match app-id=r#"^(vlc)(\.wrapped|-wrapped)?$"#
        open-floating true
    }

    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    window-rule {
        match app-id=r#"^((com\.mitchellh\.ghostty|ghostty)(\.wrapped|-wrapped)?)$"#
        opacity 0.9
    }

    // ── Keybinds ───────────────────────────────────────────
    binds {
        // Terminal & window management
        Mod+Q { spawn "ghostty" "+new-window"; }
        Mod+F4 { close-window; }
        Mod+V { toggle-window-floating; }
        Mod+Shift+Space { switch-focus-between-floating-and-tiling; }
        Mod+F { fullscreen-window; }

        // Screenshot, wallpaper, lock
        Mod+S { screenshot; }
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }
        Mod+R { spawn "change-wallpaper"; }
        Mod+O { spawn "hyprlock"; }

        // Overview
        Mod+D { toggle-overview; }

        // Launchers
        Alt+Space { spawn "qs-app-launcher"; }
        Mod+M { spawn "qs-power-menu"; }

        // Theme toggle
        Mod+Shift+T { spawn "switch-theme" "--toggle"; }
        Mod+T { consume-or-expel-window-left; }

        // Focus: columns left/right, windows up/down
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-up; }
        Mod+J { focus-window-down; }
        Alt+Tab { focus-window-down; }

        // Move: columns left/right, windows up/down
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+J { move-window-down; }

        // Focus monitor
        Mod+Ctrl+H { focus-monitor-left; }
        Mod+Ctrl+L { focus-monitor-right; }
        Mod+Ctrl+K { focus-monitor-up; }
        Mod+Ctrl+J { focus-monitor-down; }

        // Move window to monitor
        Mod+Shift+Ctrl+H { move-window-to-monitor-left; }
        Mod+Shift+Ctrl+L { move-window-to-monitor-right; }
        Mod+Shift+Ctrl+K { move-window-to-monitor-up; }
        Mod+Shift+Ctrl+J { move-window-to-monitor-down; }

        // Workspaces (per monitor)
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+0 { focus-workspace 10; }

        // Move window to workspace
        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }
        Mod+Shift+6 { move-window-to-workspace 6; }
        Mod+Shift+7 { move-window-to-workspace 7; }
        Mod+Shift+8 { move-window-to-workspace 8; }
        Mod+Shift+9 { move-window-to-workspace 9; }
        Mod+Shift+0 { move-window-to-workspace 10; }

        // Cycle focus
        Mod+Tab { focus-window-or-workspace-down; }

        // Column width presets
        Mod+Ctrl+R { switch-preset-column-width; }

        // Consume/expel windows into/from columns
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        // App shortcuts
        Alt+T        { spawn "Telegram"; }
        Alt+Shift+T  { spawn "thunar"; }
        Alt+F        { spawn "firefox"; }
        Alt+Shift+F  { spawn "firefox" "--private-window"; }
        Alt+O        { spawn "obsidian"; }
        Alt+N        { spawn "neovide"; }
        Alt+Shift+O  { spawn "okular"; }
        Alt+B        { spawn "blueman-manager"; }
        Alt+Shift+B  { spawn "bruno"; }

        // Media keys
        XF86MonBrightnessDown allow-when-locked=true { spawn "/etc/profiles/per-user/stalbar/bin/brightness" "--dec"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "/etc/profiles/per-user/stalbar/bin/brightness" "--inc"; }
        XF86AudioRaiseVolume  allow-when-locked=true { spawn "/etc/profiles/per-user/stalbar/bin/volume" "--inc"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn "/etc/profiles/per-user/stalbar/bin/volume" "--dec"; }
        XF86AudioMute         allow-when-locked=true { spawn "/etc/profiles/per-user/stalbar/bin/volume" "--mute-volume"; }
        XF86AudioMicMute      allow-when-locked=true { spawn "/etc/profiles/per-user/stalbar/bin/volume" "--mute-mic"; }

        // Quit session
        Mod+Shift+E { quit; }
    }

    environment {
        NIXOS_OZONE_WL "1"
    }
  '';
in
{
  xdg.configFile."niri/config.kdl".text = configKdl;
}
