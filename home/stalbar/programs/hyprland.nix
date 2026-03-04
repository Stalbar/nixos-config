{ pkgs, nord, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$fileManager" = "thunar";
      # Launcher and power menu are on-demand Quickshell widgets.
      "$launcher" = "qs-app-launcher";
      "$powermenu" = "qs-power-menu";

      monitor = ",preferred,auto,1";

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "waybar"
        "nm-applet --indicator"
        "blueman-applet"
        "swww-daemon"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:win_space_toggle";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          middle_button_emulation = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        resize_on_border = true;
        layout = "dwindle";
        "col.active_border" = "rgba(${nord.nord15}ee) rgba(${nord.nord10}cc) 45deg";
        "col.inactive_border" = "rgba(${nord.nord0}55)";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.97;
        dim_inactive = true;
        dim_strength = 0.04;

        blur = {
          enabled = true;
          size = 5;
          passes = 1;
          new_optimizations = true;
          xray = false;
          noise = 0.01;
          contrast = 0.95;
          brightness = 0.90;
          vibrancy = 0.08;
          vibrancy_darkness = 0.25;
          popups = true;
          popups_ignorealpha = 0.2;
        };

        shadow = {
          enabled = false;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "soft, 0.25, 0.10, 0.25, 1.00"
          "decel, 0.05, 0.70, 0.10, 1.00"
        ];
        animation = [
          "windows, 1, 4, soft, slide"
          "windowsOut, 1, 4, decel, popin 95%"
          "workspaces, 1, 3, decel, slidefade 10%"
          "fade, 1, 4, soft"
          "border, 1, 5, soft"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = false;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
      };

      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, F4, killactive"
        "$mod, V, togglefloating"
        "$mod, S, exec, grimblast --freeze --wait 0.60 save area - | swappy -f -"
        "$mod, R, exec, change-wallpaper"
        "$mod, O, exec, hyprlock"
        "ALT, SPACE, exec, $launcher"
        "$mod, M, exec, $powermenu"
        "$mod, F, fullscreen"
        "$mod, T, togglesplit"

        "ALT, Tab, cyclenext"
        "ALT, Tab, bringactivetotop"

        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod SHIFT, h, swapwindow, l"
        "$mod SHIFT, l, swapwindow, r"
        "$mod SHIFT, k, swapwindow, u"
        "$mod SHIFT, j, swapwindow, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"

        "ALT, T, exec, Telegram"
        "ALT SHIFT, T, exec, thunar"
        "ALT, F, exec, firefox"
        "ALT SHIFT, F, exec, firefox --private-window"
        "ALT, O, exec, obsidian"
        "ALT, N, exec, neovide"
        "ALT SHIFT, O, exec, okular"
        "ALT, B, exec, blueman-manager"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      binde = [
        ", xf86MonBrightnessDown, exec, /etc/profiles/per-user/stalbar/bin/brightness --dec"
        ", xf86MonBrightnessUp, exec, /etc/profiles/per-user/stalbar/bin/brightness --inc"
        ", xf86AudioRaiseVolume, exec, /etc/profiles/per-user/stalbar/bin/volume --inc"
        ", xf86AudioLowerVolume, exec, /etc/profiles/per-user/stalbar/bin/volume --dec"
        ", xf86AudioMute, exec, /etc/profiles/per-user/stalbar/bin/volume --mute-volume"
        ", xf86AudioMicMute, exec, /etc/profiles/per-user/stalbar/bin/volume --mute-mic"
      ];

      layerrule = [
        "blur on, ignore_alpha 0.10, match:namespace wallpaper_picker"
        "blur on, ignore_alpha 0.15, match:namespace waybar"
        "blur_popups on, match:namespace waybar"
        "blur on, ignore_alpha 0.10, match:namespace quickshell"
        "animation popin, match:namespace quickshell"
        "blur off, match:namespace swww-daemon"
        "blur on, ignore_alpha 0.35, match:namespace quickshell:powermenu"
      ];

      windowrule = [
        "match:modal true, float on, center on, pin on"

        "match:title ^(Open File|Save File|Save As|Preferences|Settings|Properties)$, float on, center on, pin on"
        "match:title ^(Authentication Required|Permission Required)$, float on, center on, pin on"

        "match:class ^\\.?((org\\.pulseaudio\\.pavucontrol|pavucontrol)(\\.wrapped|-wrapped)?)$, float on, center on, pin on, size 520 520"
        "match:class ^\\.?((org\\.pulseaudio\\.pavucontrol|pavucontrol)(\\.wrapped|-wrapped)?)$, stay_focused on"

        "match:class ^\\.?((blueman-manager|org\\.blueman\\.Manager)(\\.wrapped|-wrapped)?)$, float on, center on, pin on, size 760 520"
        "match:class ^\\.?((blueman-manager|org\\.blueman\\.Manager)(\\.wrapped|-wrapped)?)$, stay_focused on"

        "match:class ^\\.?((com\\.transmissionbt\\.transmission_.*|transmission-gtk)(\\.wrapped|-wrapped)?)$, no_max_size on"
        "match:class ^\\.?org\\.kde\\.okular(\\.wrapped|-wrapped)?$, no_max_size on"
        "match:class ^\\.?libreoffice-startcenter(\\.wrapped|-wrapped)?$, no_max_size on"
        "match:class ^\\.?obsidian(\\.wrapped|-wrapped)?$, no_max_size on"
        "match:class ^\\.?org\\.telegram\\.desktop(\\.wrapped|-wrapped)?$, no_max_size on"

        "match:class ^\\.?vlc(\\.wrapped|-wrapped)?$, float on, center on"

        "match:class ^\\.?kitty(\\.wrapped|-wrapped)?$, opacity 0.92 0.92"
        "match:class ^\\.?org\\.kde\\.okular(\\.wrapped|-wrapped)?$, opacity 1.0 1.0"
        "match:class ^\\.?neovide(\\.wrapped|-wrapped)?$, opacity 0.92 0.92"
      ];
    };
  };
}
