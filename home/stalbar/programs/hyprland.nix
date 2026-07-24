{ lib, pkgs, ... }:

let
  colors = import ../theme/colors.nix;
in
{
  xdg.configFile."hypr/hyprland.lua".text = "# Hyprland uses hyprland.conf\n";

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    settings = {
      "$mainMod" = "SUPER";

      monitor = [
        "HDMI-A-1, highres, auto, 1.25"
        "eDP-1, highrr, 0x0, 1"
        ", preferred, auto, 1"
      ];

      workspace = [
        "1, monitor:HDMI-A-1, default:true"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"
        "11, monitor:eDP-1, default:true"
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

        "col.active_border" = "rgba(7dcfffee) rgba(bb9af7cc) 45deg";
        "col.inactive_border" = "rgba(1a1b2655)";
      };

      decoration = {
        rounding = 12;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        dim_inactive = false;

        blur = {
          enabled = true;
          size = 10;
          passes = 3;
          new_optimizations = true;
          popups = true;
        };

        shadow = {
          enabled = false;
        };
      };

      dwindle = {
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      exec-once = [
        "change-wallpaper --reapply"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "nm-applet --indicator"
        "blueman-applet"
        "mkdir -p $HOME/Pictures/Screenshots"
      ];

      bind = [
        "$mainMod, Q, exec, foot"
        "$mainMod, F4, killactive,"
        "$mainMod, V, togglefloating,"
        "ALT, SPACE, exec, qs-app-launcher"
        "$mainMod, SPACE, exec, qs-app-launcher"
        "$mainMod, M, exec, qs-power-menu"
        "$mainMod, N, exec, qs-action-center"
        "$mainMod, R, exec, change-wallpaper"
        "$mainMod, F, fullscreen, 0"

        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        "$mainMod ALT, H, swapwindow, l"
        "$mainMod ALT, L, swapwindow, r"
        "$mainMod ALT, K, swapwindow, u"
        "$mainMod ALT, J, swapwindow, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 0, workspace, 11"

        "$mainMod ALT, 1, movetoworkspace, 1"
        "$mainMod ALT, 2, movetoworkspace, 2"
        "$mainMod ALT, 3, movetoworkspace, 3"
        "$mainMod ALT, 4, movetoworkspace, 4"
        "$mainMod ALT, 5, movetoworkspace, 5"
        "$mainMod ALT, 0, movetoworkspace, 11"

        "ALT, N, exec, neovide --no-fork"
        "ALT, F, exec, zen"
        "ALT, C, exec, chromium --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "ALT, B, exec, blueman-manager"

        # Screenshots
        ", Print, exec, grimblast --notify copysave area ~/Pictures/Screenshots/screenshot.png"
        "$mainMod, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
      ];

      binde = [
        ", XF86AudioRaiseVolume, exec, volume --inc"
        ", XF86AudioLowerVolume, exec, volume --dec"
        ", XF86MonBrightnessUp, exec, brightness --inc"
        ", XF86MonBrightnessDown, exec, brightness --dec"
      ];

      bindl = [
        ", XF86AudioMute, exec, volume --mute-volume"
        ", XF86AudioMicMute, exec, volume --mute-mic"
      ];
    };
  };
}
