{ lib, pkgs, ... }:

let
  colors = import ../theme/colors.nix;
  lua = lib.generators.mkLuaInline;

  bind =
    keys: dispatcher: opts:
    {
      _args = [ keys dispatcher ] ++ lib.optional (opts != null) opts;
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
        # Core App Binds
        (bind "SUPER + Q" (lua ''hl.dsp.exec_cmd("foot")'') null)
        (bind "SUPER + F4" (lua ''hl.dsp.window.close()'') null)
        (bind "SUPER + V" (lua ''hl.dsp.window.float({ toggle = true })'') null)
        (bind "ALT + SPACE" (lua ''hl.dsp.exec_cmd("qs-app-launcher")'') null)
        (bind "SUPER + SPACE" (lua ''hl.dsp.exec_cmd("qs-app-launcher")'') null)
        (bind "SUPER + M" (lua ''hl.dsp.exec_cmd("qs-power-menu")'') null)
        (bind "SUPER + N" (lua ''hl.dsp.exec_cmd("qs-action-center")'') null)
        (bind "SUPER + R" (lua ''hl.dsp.exec_cmd("change-wallpaper")'') null)
        (bind "SUPER + F" (lua ''hl.dsp.window.fullscreen()'') null)

        # Directional Focus & Movement
        (bind "SUPER + H" (lua ''hl.dsp.focus({ direction = "l" })'') null)
        (bind "SUPER + L" (lua ''hl.dsp.focus({ direction = "r" })'') null)
        (bind "SUPER + K" (lua ''hl.dsp.focus({ direction = "u" })'') null)
        (bind "SUPER + J" (lua ''hl.dsp.focus({ direction = "d" })'') null)

        (bind "SUPER + ALT + H" (lua ''hl.dsp.window.move({ direction = "l" })'') null)
        (bind "SUPER + ALT + L" (lua ''hl.dsp.window.move({ direction = "r" })'') null)
        (bind "SUPER + ALT + K" (lua ''hl.dsp.window.move({ direction = "u" })'') null)
        (bind "SUPER + ALT + J" (lua ''hl.dsp.window.move({ direction = "d" })'') null)

        # Virtual Desktops Focus
        (bind "SUPER + 1" (lua ''hl.dsp.focus({ workspace = 1 })'') null)
        (bind "SUPER + 2" (lua ''hl.dsp.focus({ workspace = 2 })'') null)
        (bind "SUPER + 3" (lua ''hl.dsp.focus({ workspace = 3 })'') null)
        (bind "SUPER + 4" (lua ''hl.dsp.focus({ workspace = 4 })'') null)
        (bind "SUPER + 5" (lua ''hl.dsp.focus({ workspace = 5 })'') null)
        (bind "SUPER + 6" (lua ''hl.dsp.focus({ workspace = 6 })'') null)
        (bind "SUPER + 7" (lua ''hl.dsp.focus({ workspace = 7 })'') null)
        (bind "SUPER + 8" (lua ''hl.dsp.focus({ workspace = 8 })'') null)
        (bind "SUPER + 9" (lua ''hl.dsp.focus({ workspace = 9 })'') null)
        (bind "SUPER + 0" (lua ''hl.dsp.focus({ workspace = 11 })'') null)

        # Virtual Desktops Window Movement
        (bind "SUPER + SHIFT + 1" (lua ''hl.dsp.window.move({ workspace = 1 })'') null)
        (bind "SUPER + SHIFT + 2" (lua ''hl.dsp.window.move({ workspace = 2 })'') null)
        (bind "SUPER + SHIFT + 3" (lua ''hl.dsp.window.move({ workspace = 3 })'') null)
        (bind "SUPER + SHIFT + 4" (lua ''hl.dsp.window.move({ workspace = 4 })'') null)
        (bind "SUPER + SHIFT + 5" (lua ''hl.dsp.window.move({ workspace = 5 })'') null)
        (bind "SUPER + SHIFT + 6" (lua ''hl.dsp.window.move({ workspace = 6 })'') null)
        (bind "SUPER + SHIFT + 7" (lua ''hl.dsp.window.move({ workspace = 7 })'') null)
        (bind "SUPER + SHIFT + 8" (lua ''hl.dsp.window.move({ workspace = 8 })'') null)
        (bind "SUPER + SHIFT + 9" (lua ''hl.dsp.window.move({ workspace = 9 })'') null)
        (bind "SUPER + SHIFT + 0" (lua ''hl.dsp.window.move({ workspace = 11 })'') null)

        (bind "SUPER + ALT + 1" (lua ''hl.dsp.window.move({ workspace = 1 })'') null)
        (bind "SUPER + ALT + 2" (lua ''hl.dsp.window.move({ workspace = 2 })'') null)
        (bind "SUPER + ALT + 3" (lua ''hl.dsp.window.move({ workspace = 3 })'') null)
        (bind "SUPER + ALT + 4" (lua ''hl.dsp.window.move({ workspace = 4 })'') null)
        (bind "SUPER + ALT + 5" (lua ''hl.dsp.window.move({ workspace = 5 })'') null)
        (bind "SUPER + ALT + 6" (lua ''hl.dsp.window.move({ workspace = 6 })'') null)
        (bind "SUPER + ALT + 7" (lua ''hl.dsp.window.move({ workspace = 7 })'') null)
        (bind "SUPER + ALT + 8" (lua ''hl.dsp.window.move({ workspace = 8 })'') null)
        (bind "SUPER + ALT + 9" (lua ''hl.dsp.window.move({ workspace = 9 })'') null)
        (bind "SUPER + ALT + 0" (lua ''hl.dsp.window.move({ workspace = 11 })'') null)

        # Applications Shortcuts
        (bind "ALT + N" (lua ''hl.dsp.exec_cmd("neovide --no-fork")'') null)
        (bind "ALT + F" (lua ''hl.dsp.exec_cmd("zen")'') null)
        (bind "ALT + C" (lua ''hl.dsp.exec_cmd("chromium --enable-features=UseOzonePlatform --ozone-platform=wayland")'') null)
        (bind "ALT + B" (lua ''hl.dsp.exec_cmd("blueman-manager")'') null)

        # Screenshots
        (bind "Print" (lua ''hl.dsp.exec_cmd("grimblast --notify copysave area ~/Pictures/Screenshots/screenshot.png")'') null)
        (bind "SUPER + S" (lua ''hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f -")'') null)

        # Hardware Keys (XF86 volume & brightness keys)
        (bind "XF86AudioRaiseVolume" (lua ''hl.dsp.exec_cmd("volume --inc")'') { "repeat" = true; locked = true; })
        (bind "XF86AudioLowerVolume" (lua ''hl.dsp.exec_cmd("volume --dec")'') { "repeat" = true; locked = true; })
        (bind "XF86AudioMute" (lua ''hl.dsp.exec_cmd("volume --mute-volume")'') { locked = true; })
        (bind "XF86AudioMicMute" (lua ''hl.dsp.exec_cmd("volume --mute-mic")'') { locked = true; })
        (bind "XF86MonBrightnessUp" (lua ''hl.dsp.exec_cmd("brightness --inc")'') { "repeat" = true; locked = true; })
        (bind "XF86MonBrightnessDown" (lua ''hl.dsp.exec_cmd("brightness --dec")'') { "repeat" = true; locked = true; })
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
              end
            '')
          ];
        }
      ];
    };
  };
}
