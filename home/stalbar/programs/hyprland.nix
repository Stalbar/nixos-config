{ lib, pkgs, nord, ... }:

let
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
        _var = "ghostty +new-window";
      };

      browser = {
        _var = "firefox";
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

      workspace_rule = [
        {
          workspace = "1";
          monitor = "eDP-1";
          default = true;
          persistent = true;
        }
        {
          workspace = "2";
          monitor = "HDMI-A-1";
          default = true;
          persistent = true;
        }
        {
          workspace = "3";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "4";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "5";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "6";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "7";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "8";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "9";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "10";
          monitor = "HDMI-A-1";
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
                "rgba(${nord.nord15}ee)"
                "rgba(${nord.nord10}cc)"
              ];
              angle = 45;
            };
            inactive_border = "rgba(${nord.nord0}55)";
          };
        };

        decoration = {
          rounding = 12;
          active_opacity = 0.98;
          inactive_opacity = 0.94;
          dim_inactive = true;
          dim_strength = 0.06;

          blur = {
            enabled = true;
            size = 10;
            passes = 3;
            new_optimizations = true;
            xray = false;
            noise = 0.011;
            contrast = 0.96;
            brightness = 0.80;
            vibrancy = 0.20;
            vibrancy_darkness = 0.22;
            popups = true;
            popups_ignorealpha = 0.10;
          };

          shadow = {
            enabled = false;
          };
        };

        animations = {
          enabled = false;
        };

        dwindle = {
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        debug = {
          vfr = true;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          focus_on_activate = false;
          animate_manual_resizes = false;
          animate_mouse_windowdragging = false;
        };
      };

      device = [
        {
          name = "elan1200:00-04f3:30ba-touchpad";
          enabled = true;
        }
      ];

      layer_rule = [
        {
          name = "wallpaper-picker-glass";
          blur = true;
          ignore_alpha = 0.10;
          match = {
            namespace = "wallpaper_picker";
          };
        }
        {
          name = "waybar-glass";
          blur = true;
          ignore_alpha = 0.15;
          match = {
            namespace = "waybar";
          };
        }
        {
          name = "waybar-popups";
          blur_popups = true;
          match = {
            namespace = "waybar";
          };
        }
        {
          name = "quickshell-glass";
          blur = true;
          ignore_alpha = 0.10;
          match = {
            namespace = "quickshell";
          };
        }
        {
          name = "quickshell-anim";
          animation = "popin";
          match = {
            namespace = "quickshell";
          };
        }
        {
          name = "awww-no-blur";
          blur = false;
          match = {
            namespace = "awww-daemon";
          };
        }
        {
          name = "powermenu-stronger-glass";
          blur = true;
          ignore_alpha = 0.35;
          match = {
            namespace = "quickshell:powermenu";
          };
        }
      ];

      window_rule = [
        {
          name = "modal-dialogs";
          match = {
            modal = true;
          };
          float = true;
          center = true;
          pin = true;
        }
        {
          name = "generic-file-dialogs";
          match = {
            title = "^(Open File|Save File|Save As|Preferences|Settings|Properties)$";
          };
          float = true;
          center = true;
          pin = true;
        }
        {
          name = "auth-dialogs";
          match = {
            title = "^(Authentication Required|Permission Required)$";
          };
          float = true;
          center = true;
          pin = true;
        }
        {
          name = "pavucontrol-float";
          match = {
            class = "^\\.?((org\\.pulseaudio\\.pavucontrol|pavucontrol)(\\.wrapped|-wrapped)?)$";
          };
          float = true;
          center = true;
          pin = true;
          size = "520 520";
        }
        {
          name = "pavucontrol-focus";
          match = {
            class = "^\\.?((org\\.pulseaudio\\.pavucontrol|pavucontrol)(\\.wrapped|-wrapped)?)$";
          };
          stay_focused = true;
        }
        {
          name = "blueman-float";
          match = {
            class = "^\\.?((blueman-manager|org\\.blueman\\.Manager)(\\.wrapped|-wrapped)?)$";
          };
          float = true;
          center = true;
          pin = true;
          size = "760 520";
        }
        {
          name = "blueman-focus";
          match = {
            class = "^\\.?((blueman-manager|org\\.blueman\\.Manager)(\\.wrapped|-wrapped)?)$";
          };
          stay_focused = true;
        }
        {
          name = "transmission-max";
          match = {
            class = "^\\.?((com\\.transmissionbt\\.transmission_.*|transmission-gtk)(\\.wrapped|-wrapped)?)$";
          };
          no_max_size = true;
        }
        {
          name = "okular-max";
          match = {
            class = "^\\.?org\\.kde\\.okular(\\.wrapped|-wrapped)?$";
          };
          no_max_size = true;
        }
        {
          name = "libreoffice-max";
          match = {
            class = "^\\.?libreoffice-startcenter(\\.wrapped|-wrapped)?$";
          };
          no_max_size = true;
        }
        {
          name = "obsidian-max";
          match = {
            class = "^\\.?obsidian(\\.wrapped|-wrapped)?$";
          };
          no_max_size = true;
        }
        {
          name = "telegram-max";
          match = {
            class = "^\\.?org\\.telegram\\.desktop(\\.wrapped|-wrapped)?$";
          };
          no_max_size = true;
        }
        {
          name = "vlc-float";
          match = {
            class = "^\\.?vlc(\\.wrapped|-wrapped)?$";
          };
          float = true;
          center = true;
        }
        {
          name = "ghostty-opacity";
          match = {
            class = "^\\.?((com\\.mitchellh\\.ghostty|ghostty)(\\.wrapped|-wrapped)?)$";
          };
          opacity = "0.95 0.93";
        }
        {
          name = "okular-opacity";
          match = {
            class = "^\\.?org\\.kde\\.okular(\\.wrapped|-wrapped)?$";
          };
          opacity = "1.0 1.0";
        }
        {
          name = "neovide-opacity";
          match = {
            class = "^\\.?neovide(\\.wrapped|-wrapped)?$";
          };
          opacity = "0.96 0.94";
        }
      ];

      bind = [
        (bind (mod "Q") (lua "hl.dsp.exec_cmd(terminal)") null)
        (bind (mod "F4") (lua "hl.dsp.window.close()") null)
        (bind (mod "V") (lua "hl.dsp.window.float({ action = \"toggle\" })") null)
        (bind (mod "S") (exec "grimblast --freeze --wait 0.60 save area - | swappy -f -") null)
        (bind (mod "R") (exec "change-wallpaper") null)
        (bind (mod "O") (exec "hyprlock") null)
        (bind "ALT + SPACE" (lua "hl.dsp.exec_cmd(launcher)") null)
        (bind (mod "M") (lua "hl.dsp.exec_cmd(powerMenu)") null)
        (bind (mod "F") (lua "hl.dsp.window.fullscreen()") null)
        (bind (mod "T") (lua "hl.dsp.layout(\"togglesplit\")") null)
        (bind (mod "SHIFT + T") (exec "switch-theme --toggle") null)
        (bind
          "ALT + TAB"
          (lua ''
            function()
              hl.dispatch(hl.dsp.window.cycle_next())
              hl.dispatch(hl.dsp.window.bring_to_top())
            end
          '')
          null)
        (bind (mod "H") (focusDir "left") null)
        (bind (mod "L") (focusDir "right") null)
        (bind (mod "K") (focusDir "up") null)
        (bind (mod "J") (focusDir "down") null)
        (bind (mod "SHIFT + H") (swapDir "left") null)
        (bind (mod "SHIFT + L") (swapDir "right") null)
        (bind (mod "SHIFT + K") (swapDir "up") null)
        (bind (mod "SHIFT + J") (swapDir "down") null)
        (bind (mod "1") (lua "hl.dsp.focus({ workspace = 1 })") null)
        (bind (mod "2") (lua "hl.dsp.focus({ workspace = 2 })") null)
        (bind (mod "3") (lua "hl.dsp.focus({ workspace = 3 })") null)
        (bind (mod "4") (lua "hl.dsp.focus({ workspace = 4 })") null)
        (bind (mod "5") (lua "hl.dsp.focus({ workspace = 5 })") null)
        (bind (mod "6") (lua "hl.dsp.focus({ workspace = 6 })") null)
        (bind (mod "7") (lua "hl.dsp.focus({ workspace = 7 })") null)
        (bind (mod "8") (lua "hl.dsp.focus({ workspace = 8 })") null)
        (bind (mod "9") (lua "hl.dsp.focus({ workspace = 9 })") null)
        (bind (mod "0") (lua "hl.dsp.focus({ workspace = 10 })") null)
        (bind (mod "SHIFT + 1") (lua "hl.dsp.window.move({ workspace = 1 })") null)
        (bind (mod "SHIFT + 2") (lua "hl.dsp.window.move({ workspace = 2 })") null)
        (bind (mod "SHIFT + 3") (lua "hl.dsp.window.move({ workspace = 3 })") null)
        (bind (mod "SHIFT + 4") (lua "hl.dsp.window.move({ workspace = 4 })") null)
        (bind (mod "SHIFT + 5") (lua "hl.dsp.window.move({ workspace = 5 })") null)
        (bind (mod "SHIFT + 6") (lua "hl.dsp.window.move({ workspace = 6 })") null)
        (bind (mod "SHIFT + 7") (lua "hl.dsp.window.move({ workspace = 7 })") null)
        (bind (mod "SHIFT + 8") (lua "hl.dsp.window.move({ workspace = 8 })") null)
        (bind (mod "SHIFT + 9") (lua "hl.dsp.window.move({ workspace = 9 })") null)
        (bind (mod "SHIFT + 0") (lua "hl.dsp.window.move({ workspace = 10 })") null)
        (bind "ALT + T" (exec "Telegram") null)
        (bind "ALT + SHIFT + T" (lua "hl.dsp.exec_cmd(fileManager)") null)
        (bind "ALT + F" (lua "hl.dsp.exec_cmd(browser)") null)
        (bind "ALT + SHIFT + F" (exec "firefox --private-window") null)
        (bind "ALT + O" (exec "obsidian") null)
        (bind "ALT + N" (exec "neovide") null)
        (bind "ALT + SHIFT + O" (exec "okular") null)
        (bind "ALT + B" (exec "blueman-manager") null)
        (bind "ALT + SHIFT + B" (exec "bruno") null)
        (bind
          (mod "mouse:272")
          (lua "hl.dsp.window.drag()")
          {
            mouse = true;
          })
        (bind
          (mod "mouse:273")
          (lua "hl.dsp.window.resize()")
          {
            mouse = true;
          })
        (bind
          "XF86MonBrightnessDown"
          (exec "/etc/profiles/per-user/stalbar/bin/brightness --dec")
          {
            locked = true;
            repeating = true;
          })
        (bind
          "XF86MonBrightnessUp"
          (exec "/etc/profiles/per-user/stalbar/bin/brightness --inc")
          {
            locked = true;
            repeating = true;
          })
        (bind
          "XF86AudioRaiseVolume"
          (exec "/etc/profiles/per-user/stalbar/bin/volume --inc")
          {
            locked = true;
            repeating = true;
          })
        (bind
          "XF86AudioLowerVolume"
          (exec "/etc/profiles/per-user/stalbar/bin/volume --dec")
          {
            locked = true;
            repeating = true;
          })
        (bind
          "XF86AudioMute"
          (exec "/etc/profiles/per-user/stalbar/bin/volume --mute-volume")
          {
            locked = true;
            repeating = true;
          })
        (bind
          "XF86AudioMicMute"
          (exec "/etc/profiles/per-user/stalbar/bin/volume --mute-mic")
          {
            locked = true;
            repeating = true;
          })
      ];

      on = [
        {
          _args = [
            "hyprland.start"
            (lua ''
              function()
                hl.exec_cmd("switch-theme --apply-current")
                hl.exec_cmd(${builtins.toJSON "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"})
                hl.exec_cmd("nm-applet --indicator")
                hl.exec_cmd("blueman-applet")
                hl.exec_cmd("awww-daemon")
              end
            '')
          ];
        }
      ];
    };
  };
}
