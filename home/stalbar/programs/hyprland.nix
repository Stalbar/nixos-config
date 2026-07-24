{ lib, pkgs, ... }:

let
  colors = import ../theme/colors.nix;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      mainMod = {
        _var = "SUPER";
        name = "mainMod";
      };

      terminal = {
        _var = "foot";
      };

      browser = {
        _var = "zen";
      };

      fileManager = {
        _var = "thunar";
      };

      launcher = {
        _var = "qs-app-launcher";
      };

      powerMenu = {
        _var = "qs-power-menu";
        name = "powerMenu";
      };

      monitor = [
        {
          output = "HDMI-A-1";
          mode = "highres";
          position = "auto";
          scale = 1.25;
        }
        {
          output = "eDP-1";
          mode = "highrr";
          position = "0x0";
          scale = 1;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

      config = {
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

          col = {
            active_border = {
              colors = [
                "rgba(7dcfffee)"
                "rgba(bb9af7cc)"
              ];
              angle = 45;
            };
            inactive_border = "rgba(1a1b2655)";
          };
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
      };

      bind = [
        "SUPER, Q, exec, foot"
        "SUPER, F4, killactive,"
        "SUPER, V, togglefloating,"
        "ALT, SPACE, exec, qs-app-launcher"
        "SUPER, SPACE, exec, qs-app-launcher"
        "SUPER, M, exec, qs-power-menu"
        "SUPER, N, exec, qs-action-center"
        "SUPER, R, exec, change-wallpaper"
        "SUPER, F, fullscreen, 0"

        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        "SUPER ALT, H, swapwindow, l"
        "SUPER ALT, L, swapwindow, r"
        "SUPER ALT, K, swapwindow, u"
        "SUPER ALT, J, swapwindow, d"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 0, workspace, 11"

        "SUPER ALT, 1, movetoworkspace, 1"
        "SUPER ALT, 2, movetoworkspace, 2"
        "SUPER ALT, 3, movetoworkspace, 3"
        "SUPER ALT, 4, movetoworkspace, 4"
        "SUPER ALT, 5, movetoworkspace, 5"
        "SUPER ALT, 0, movetoworkspace, 11"

        "ALT, N, exec, neovide --no-fork"
        "ALT, F, exec, zen"
        "ALT, C, exec, chromium --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "ALT, B, exec, blueman-manager"

        # Screenshots
        ", Print, exec, grimblast --notify copysave area ~/Pictures/Screenshots/screenshot.png"
        "SUPER, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
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

      on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("change-wallpaper --reapply")
                hl.exec_cmd(${builtins.toJSON "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"})
                hl.exec_cmd("nm-applet --indicator")
                hl.exec_cmd("blueman-applet")
                hl.exec_cmd("mkdir -p $HOME/Pictures/Screenshots")
                hl.exec_cmd("hyprctl keyword workspace 1,monitor:HDMI-A-1,default:true")
                hl.exec_cmd("hyprctl keyword workspace 2,monitor:HDMI-A-1")
                hl.exec_cmd("hyprctl keyword workspace 3,monitor:HDMI-A-1")
                hl.exec_cmd("hyprctl keyword workspace 4,monitor:HDMI-A-1")
                hl.exec_cmd("hyprctl keyword workspace 5,monitor:HDMI-A-1")
                hl.exec_cmd("hyprctl keyword workspace 11,monitor:eDP-1,default:true")
              end
            '')
          ];
        }
      ];
    };
  };
}
