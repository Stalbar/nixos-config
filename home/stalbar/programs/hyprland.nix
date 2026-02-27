{ nord, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      windowrule {
        name = pavucontrol-floating
        match:class = ^(pavucontrol)$

        float = yes
        center = yes
        size = 60% 60%
      }
    '';
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$fileManager" = "thunar";
      monitor = ",preferred,auto,1";

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          middle_button_emulation = true;
        };
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        resize_on_border = true;
        layout = "dwindle";
        "col.active_border" = "rgb(${nord.nord10})";
        "col.inactive_border" = "rgb(${nord.nord3})";
      };

      decoration = {
        rounding = 6;
        active_opacity = 1.0;
        inactive_opacity = 0.97;
        blur = {
          enabled = false;
        };
        shadow = {
          enabled = false;
        };
      };

      animations = {
        enabled = false;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
      };

      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, B, exec, $browser"
        "ALT, F, exec, firefox"
        "ALT, T, exec, telegram-desktop"
        "ALT SHIFT, T, exec, $fileManager"
        "$mod, F4, killactive"
        "$mod, F, fullscreen, 1"
        "$mod, V, togglefloating"
        "$mod, T, togglesplit"
        "$mod, S, exec, grimblast --freeze --wait 0.60 copy area"

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
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

    };
  };
}
