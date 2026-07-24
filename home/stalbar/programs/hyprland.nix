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

  exec = cmd: lua ''hl.dsp.exec_cmd(${builtins.toJSON cmd})'';

  focusDir = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
  swapDir = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
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
          output = "eDP-1";
          mode = "1920x1080@120.03";
          position = "0x0";
          scale = 1;
        }
        {
          output = "HDMI-A-1";
          mode = "2560x1440@59.95";
          position = "1920x0";
          scale = 1.25;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

      workspace = [
        "1, monitor:HDMI-A-1, default:true"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"
        "11, monitor:eDP-1, default:true"
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
        (bind (mod "Q") (lua "hl.dsp.exec_cmd(terminal)") null)
        (bind (mod "F4") (lua "hl.dsp.window.close()") null)
        (bind (mod "V") (lua "hl.dsp.window.float({ action = \"toggle\" })") null)
        (bind "ALT + SPACE" (lua "hl.dsp.exec_cmd(launcher)") null)
        (bind (mod "SPACE") (lua "hl.dsp.exec_cmd(launcher)") null)
        (bind (mod "M") (lua "hl.dsp.exec_cmd(powerMenu)") null)
        (bind (mod "N") (exec "qs-action-center") null)
        (bind (mod "R") (exec "change-wallpaper") null)
        (bind (mod "F") (lua "hl.dsp.window.fullscreen()") null)
        (bind (mod "H") (focusDir "left") null)
        (bind (mod "L") (focusDir "right") null)
        (bind (mod "K") (focusDir "up") null)
        (bind (mod "J") (focusDir "down") null)

        # Replaced SUPER + SHIFT with SUPER + ALT for window moving & workspace moving
        (bind (mod "ALT + H") (swapDir "left") null)
        (bind (mod "ALT + L") (swapDir "right") null)
        (bind (mod "ALT + K") (swapDir "up") null)
        (bind (mod "ALT + J") (swapDir "down") null)

        (bind (mod "1") (lua "hl.dsp.focus({ workspace = 1 })") null)
        (bind (mod "2") (lua "hl.dsp.focus({ workspace = 2 })") null)
        (bind (mod "3") (lua "hl.dsp.focus({ workspace = 3 })") null)
        (bind (mod "4") (lua "hl.dsp.focus({ workspace = 4 })") null)
        (bind (mod "5") (lua "hl.dsp.focus({ workspace = 5 })") null)
        (bind (mod "0") (lua "hl.dsp.focus({ workspace = 11 })") null)

        (bind (mod "ALT + 1") (lua "hl.dsp.window.move_to_workspace({ workspace = 1 })") null)
        (bind (mod "ALT + 2") (lua "hl.dsp.window.move_to_workspace({ workspace = 2 })") null)
        (bind (mod "ALT + 3") (lua "hl.dsp.window.move_to_workspace({ workspace = 3 })") null)
        (bind (mod "ALT + 4") (lua "hl.dsp.window.move_to_workspace({ workspace = 4 })") null)
        (bind (mod "ALT + 5") (lua "hl.dsp.window.move_to_workspace({ workspace = 5 })") null)
        (bind (mod "ALT + 0") (lua "hl.dsp.window.move_to_workspace({ workspace = 11 })") null)

        (bind "ALT + N" (exec "neovide --no-fork") null)
        (bind "ALT + F" (lua "hl.dsp.exec_cmd(browser)") null)
        (bind "ALT + C" (exec "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland") null)
        (bind "ALT + B" (exec "blueman-manager") null)
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
              end
            '')
          ];
        }
      ];
    };
  };
}
