{ lib, pkgs, ... }:

let
  colors = import ../theme/colors.nix;
  lua = lib.generators.mkLuaInline;
  mod = key: lua ''mainMod .. " + ${key}"'';

  bind =
    keys: dispatcher: opts:
    {
      _args = [ keys dispatcher ] ++ lib.optional (opts != null) opts;
    };

  exec = cmd: lua ''function() hl.dsp.exec_cmd(${builtins.toJSON cmd}) end'';
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
        (bind (mod "Q") (exec "foot") null)
        (bind (mod "F4") (lua "hl.dsp.window.close()") null)
        (bind (mod "V") (exec "hyprctl dispatch togglefloating") null)
        (bind "ALT + SPACE" (exec "qs-app-launcher") null)
        (bind (mod "SPACE") (exec "qs-app-launcher") null)
        (bind (mod "M") (exec "qs-power-menu") null)
        (bind (mod "N") (exec "qs-action-center") null)
        (bind (mod "R") (exec "change-wallpaper") null)
        (bind (mod "F") (exec "hyprctl dispatch fullscreen") null)

        (bind (mod "H") (exec "hyprctl dispatch movefocus l") null)
        (bind (mod "L") (exec "hyprctl dispatch movefocus r") null)
        (bind (mod "K") (exec "hyprctl dispatch movefocus u") null)
        (bind (mod "J") (exec "hyprctl dispatch movefocus d") null)

        (bind (mod "ALT + H") (exec "hyprctl dispatch swapwindow l") null)
        (bind (mod "ALT + L") (exec "hyprctl dispatch swapwindow r") null)
        (bind (mod "ALT + K") (exec "hyprctl dispatch swapwindow u") null)
        (bind (mod "ALT + J") (exec "hyprctl dispatch swapwindow d") null)

        (bind (mod "1") (exec "hyprctl dispatch workspace 1") null)
        (bind (mod "2") (exec "hyprctl dispatch workspace 2") null)
        (bind (mod "3") (exec "hyprctl dispatch workspace 3") null)
        (bind (mod "4") (exec "hyprctl dispatch workspace 4") null)
        (bind (mod "5") (exec "hyprctl dispatch workspace 5") null)
        (bind (mod "0") (exec "hyprctl dispatch workspace 11") null)

        (bind (mod "ALT + 1") (exec "hyprctl dispatch movetoworkspace 1") null)
        (bind (mod "ALT + 2") (exec "hyprctl dispatch movetoworkspace 2") null)
        (bind (mod "ALT + 3") (exec "hyprctl dispatch movetoworkspace 3") null)
        (bind (mod "ALT + 4") (exec "hyprctl dispatch movetoworkspace 4") null)
        (bind (mod "ALT + 5") (exec "hyprctl dispatch movetoworkspace 5") null)
        (bind (mod "ALT + 0") (exec "hyprctl dispatch movetoworkspace 11") null)

        (bind "ALT + N" (exec "neovide --no-fork") null)
        (bind "ALT + F" (exec "zen") null)
        (bind "ALT + C" (exec "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland") null)
        (bind "ALT + B" (exec "blueman-manager") null)

        (bind "Print" (exec "grimblast --notify copysave area ~/Pictures/Screenshots/screenshot.png") null)
        (bind (mod "S") (exec "grim -g \"$(slurp)\" - | swappy -f -") null)

        (bind "XF86AudioRaiseVolume" (exec "volume --inc") [ "e" ])
        (bind "XF86AudioLowerVolume" (exec "volume --dec") [ "e" ])
        (bind "XF86AudioMute" (exec "volume --mute-volume") null)
        (bind "XF86AudioMicMute" (exec "volume --mute-mic") null)
        (bind "XF86MonBrightnessUp" (exec "brightness --inc") [ "e" ])
        (bind "XF86MonBrightnessDown" (exec "brightness --dec") [ "e" ])
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
