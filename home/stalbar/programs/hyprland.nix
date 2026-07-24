{ lib, pkgs, ... }:

let
  colors = import ../theme/colors.nix;
in
{
  xdg.configFile."hypr/hyprland.lua".text = "# Hyprland uses hyprland.conf\n";

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    extraConfig = ''
      $mainMod = SUPER

      # Monitors
      monitor = HDMI-A-1, 2560x1440@59.95, 0x0, 1.25
      monitor = eDP-1, 1920x1080@120.035, 2048x0, 1
      monitor = , preferred, auto, 1

      # Workspaces
      workspace = 1, monitor:HDMI-A-1, default:true
      workspace = 2, monitor:HDMI-A-1
      workspace = 3, monitor:HDMI-A-1
      workspace = 4, monitor:HDMI-A-1
      workspace = 5, monitor:HDMI-A-1
      workspace = 11, monitor:eDP-1, default:true

      # Input & General
      input {
        kb_layout = us,ru
        kb_options = grp:win_space_toggle
        follow_mouse = 1
        sensitivity = 0
        touchpad {
          natural_scroll = true
          middle_button_emulation = true
        }
      }

      general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        resize_on_border = true
        layout = dwindle
        col.active_border = rgba(7dcfffee) rgba(bb9af7cc) 45deg
        col.inactive_border = rgba(1a1b2655)
      }

      decoration {
        rounding = 12
        active_opacity = 1.0
        inactive_opacity = 1.0
        dim_inactive = false
        blur {
          enabled = true
          size = 10
          passes = 3
          new_optimizations = true
          popups = true
        }
        shadow {
          enabled = false
        }
      }

      dwindle {
        preserve_split = true
      }

      misc {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      }

      cursor {
        no_hardware_cursors = true
      }

      # Startup
      exec-once = change-wallpaper --reapply
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      exec-once = nm-applet --indicator
      exec-once = blueman-applet
      exec-once = mkdir -p $HOME/Pictures/Screenshots

      # Core Binds
      bind = $mainMod, Q, exec, foot
      bind = $mainMod, F4, killactive
      bind = $mainMod, V, togglefloating
      bind = ALT, SPACE, exec, qs-app-launcher
      bind = $mainMod, SPACE, exec, qs-app-launcher
      bind = $mainMod, M, exec, qs-power-menu
      bind = $mainMod, N, exec, qs-action-center
      bind = $mainMod, R, exec, change-wallpaper
      bind = $mainMod, F, fullscreen, 0

      # Window Direction Focus & Swap
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d

      bind = $mainMod ALT, H, swapwindow, l
      bind = $mainMod ALT, L, swapwindow, r
      bind = $mainMod ALT, K, swapwindow, u
      bind = $mainMod ALT, J, swapwindow, d

      # Virtual Desktops Focus
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 0, workspace, 11

      # Virtual Desktops Window Movement
      bind = $mainMod ALT, 1, movetoworkspace, 1
      bind = $mainMod ALT, 2, movetoworkspace, 2
      bind = $mainMod ALT, 3, movetoworkspace, 3
      bind = $mainMod ALT, 4, movetoworkspace, 4
      bind = $mainMod ALT, 5, movetoworkspace, 5
      bind = $mainMod ALT, 0, movetoworkspace, 11

      # Apps
      bind = ALT, N, exec, neovide --no-fork
      bind = ALT, F, exec, zen
      bind = ALT, C, exec, chromium --enable-features=UseOzonePlatform --ozone-platform=wayland
      bind = ALT, B, exec, blueman-manager

      # Screenshots
      bind = , Print, exec, grimblast --notify copysave area ~/Pictures/Screenshots/screenshot.png
      bind = $mainMod, S, exec, grim -g "$(slurp)" - | swappy -f -

      # Hardware Media Keys
      binde = , XF86AudioRaiseVolume, exec, volume --inc
      binde = , XF86AudioLowerVolume, exec, volume --dec
      binde = , XF86MonBrightnessUp, exec, brightness --inc
      binde = , XF86MonBrightnessDown, exec, brightness --dec

      bindl = , XF86AudioMute, exec, volume --mute-volume
      bindl = , XF86AudioMicMute, exec, volume --mute-mic
    '';
  };
}
