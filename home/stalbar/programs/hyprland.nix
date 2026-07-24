{ lib, pkgs, ... }:

let
  colors = import ../theme/colors.nix;
  lua = lib.generators.mkLuaInline;

  mkBind = mod: key: cmd: {
    _args = [
      mod
      key
      (lua "function() hl.dsp.exec_cmd(${builtins.toJSON cmd}) end")
    ];
  };

  mkBindFn = mod: key: fnStr: {
    _args = [
      mod
      key
      (lua fnStr)
    ];
  };
in
{
  xdg.configFile."hypr/hyprland.lua".text = "# Hyprland uses hyprland.conf\n";

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      mainMod = {
        _var = "SUPER";
        name = "mainMod";
      };

      monitor = [
        {
          output = "HDMI-A-1";
          mode = "2560x1440@59.95";
          position = "0x0";
          scale = 1.25;
        }
        {
          output = "eDP-1";
          mode = "1920x1080@120.035";
          position = "2048x0";
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
        (mkBind "SUPER" "Q" "foot")
        (mkBindFn "SUPER" "F4" "hl.dsp.window.close")
        (mkBind "SUPER" "V" "hyprctl dispatch togglefloating")
        (mkBind "ALT" "SPACE" "qs-app-launcher")
        (mkBind "SUPER" "SPACE" "qs-app-launcher")
        (mkBind "SUPER" "M" "qs-power-menu")
        (mkBind "SUPER" "N" "qs-action-center")
        (mkBind "SUPER" "R" "change-wallpaper")
        (mkBind "SUPER" "F" "hyprctl dispatch fullscreen")

        (mkBind "SUPER" "H" "hyprctl dispatch movefocus l")
        (mkBind "SUPER" "L" "hyprctl dispatch movefocus r")
        (mkBind "SUPER" "K" "hyprctl dispatch movefocus u")
        (mkBind "SUPER" "J" "hyprctl dispatch movefocus d")

        (mkBind "SUPER_ALT" "H" "hyprctl dispatch swapwindow l")
        (mkBind "SUPER_ALT" "L" "hyprctl dispatch swapwindow r")
        (mkBind "SUPER_ALT" "K" "hyprctl dispatch swapwindow u")
        (mkBind "SUPER_ALT" "J" "hyprctl dispatch swapwindow d")

        (mkBind "SUPER" "1" "hyprctl dispatch workspace 1")
        (mkBind "SUPER" "2" "hyprctl dispatch workspace 2")
        (mkBind "SUPER" "3" "hyprctl dispatch workspace 3")
        (mkBind "SUPER" "4" "hyprctl dispatch workspace 4")
        (mkBind "SUPER" "5" "hyprctl dispatch workspace 5")
        (mkBind "SUPER" "0" "hyprctl dispatch workspace 11")

        (mkBind "SUPER_ALT" "1" "hyprctl dispatch movetoworkspace 1")
        (mkBind "SUPER_ALT" "2" "hyprctl dispatch movetoworkspace 2")
        (mkBind "SUPER_ALT" "3" "hyprctl dispatch movetoworkspace 3")
        (mkBind "SUPER_ALT" "4" "hyprctl dispatch movetoworkspace 4")
        (mkBind "SUPER_ALT" "5" "hyprctl dispatch movetoworkspace 5")
        (mkBind "SUPER_ALT" "0" "hyprctl dispatch movetoworkspace 11")

        (mkBind "ALT" "N" "neovide --no-fork")
        (mkBind "ALT" "F" "zen")
        (mkBind "ALT" "C" "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland")
        (mkBind "ALT" "B" "blueman-manager")

        (mkBind "" "Print" "grimblast --notify copysave area ~/Pictures/Screenshots/screenshot.png")
        (mkBind "SUPER" "S" "grim -g \"$(slurp)\" - | swappy -f -")

        (mkBind "" "XF86AudioRaiseVolume" "volume --inc")
        (mkBind "" "XF86AudioLowerVolume" "volume --dec")
        (mkBind "" "XF86AudioMute" "volume --mute-volume")
        (mkBind "" "XF86AudioMicMute" "volume --mute-mic")
        (mkBind "" "XF86MonBrightnessUp" "brightness --inc")
        (mkBind "" "XF86MonBrightnessDown" "brightness --dec")
      ];

      on = [
        {
          _args = [
            "hyprland.start"
            (lua ''
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
