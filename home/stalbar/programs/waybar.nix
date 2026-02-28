{ pkgs, ... }:

let
  micScript = pkgs.writeShellScript "waybar-mic" ''
    set -eu

    status="$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null || true)"
    if [ -z "$status" ]; then
      echo "󰍭"
      exit 0
    fi

    if echo "$status" | ${pkgs.gnugrep}/bin/grep -q "\[MUTED\]"; then
      echo ""
      exit 0
    fi

    vol="$(echo "$status" | ${pkgs.gawk}/bin/awk '{ printf "%d", $2 * 100 }')"
    if [ "$vol" -lt 34 ]; then
      echo "󰍬"
    elif [ "$vol" -lt 67 ]; then
      echo "󰍭"
    else
      echo "󰍮"
    fi
  '';
in
{
  programs.waybar = {
    enable = true;
    # Start from Hyprland exec-once for predictable single-instance behavior.
    systemd.enable = false;

    settings = [
      {
        layer = "top";
        position = "right";
        width = 34;
        spacing = 3;
        margin-top = 8;
        margin-bottom = 8;
        margin-right = 3;
        margin-left = 0;

        # Vertical bar layout:
        # top = workspaces, center = tray, bottom = status icons + clock.
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "wlr/taskbar"
          "tray"
        ];
        modules-right = [
          "pulseaudio#output"
          "custom/mic"
          "battery"
          "hyprland/language"
          "clock#stack"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          sort-by-number = true;
          format = "{id}";
        };

        "pulseaudio#output" = {
          format = "{icon}";
          format-muted = "";
          format-icons = {
            default = [ "" "" "" ];
            headphone = "";
            headset = "";
          };
          scroll-step = 5;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          tooltip = true;
          tooltip-format = "{volume}%";
        };

        "custom/mic" = {
          exec = "${micScript}";
          interval = 2;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          tooltip = false;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "";
          format-plugged = "";
          format-full = "";
          format-icons = [ "" "" "" "" "" ];
          tooltip = true;
          tooltip-format = "{capacity}%";
        };

        "hyprland/language" = {
          format = "{}";
          format-en = "EN";
          format-ru = "RU";
          min-length = 2;
          tooltip = false;
        };

        tray = {
          icon-size = 22;
          spacing = 6;
          show-passive-items = true;
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 20;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };

        "clock#stack" = {
          format = "{:%H\n%M}";
          tooltip-format = "<big>{:%A, %d %B %Y}</big>";
          interval = 1;
        };
      }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font Mono", "JetBrains Mono Nerd Font Mono", monospace;
        font-size: 12px;
        min-height: 0;
        border: none;
        transition: none;
      }

      window#waybar {
        background-color: rgba(46, 52, 64, 0.96);
        border: 1px solid rgba(76, 86, 106, 0.70);
        border-radius: 12px;
        color: #D8DEE9;
      }

      #workspaces,
      #taskbar,
      #pulseaudio,
      #custom-mic,
      #battery,
      #language,
      #tray,
      #clock {
        background: transparent;
        padding: 3px 2px;
        margin: 2px 0;
      }

      #workspaces {
        padding: 4px 3px;
      }

      #taskbar {
        padding: 4px 1px;
      }

      #taskbar button {
        color: #81A1C1;
        background: transparent;
        border-radius: 8px;
        padding: 2px 0;
        margin: 1px 0;
      }

      #taskbar button.active {
        color: #88C0D0;
        background: transparent;
      }

      #workspaces button {
        color: #81A1C1;
        background: transparent;
        border-radius: 9px;
        padding: 0;
        min-width: 18px;
        min-height: 18px;
      }

      #workspaces button.active {
        color: #8FBCBB;
        background: transparent;
      }

      #workspaces button.urgent {
        color: #ECEFF4;
        background-color: rgba(191, 97, 106, 0.92);
      }

      #pulseaudio,
      #custom-mic,
      #battery {
        font-size: 23px;
        padding: 4px 0;
      }

      #pulseaudio {
        color: #8FBCBB;
      }

      #custom-mic {
        color: #88C0D0;
      }

      #battery {
        color: #A3BE8C;
      }

      #battery.warning {
        color: #D08770;
      }

      #battery.critical:not(.charging) {
        color: #BF616A;
      }

      #language {
        color: #EBCB8B;
        font-size: 11px;
        font-weight: 700;
        padding: 4px 0;
      }

      #tray {
        padding: 5px 2px;
      }

      #clock.stack {
        color: #88C0D0;
        font-size: 16px;
        font-weight: 700;
        padding: 6px 0;
      }

      tooltip {
        color: #D8DEE9;
        background-color: rgba(46, 52, 64, 0.97);
        border: 1px solid rgba(94, 129, 172, 0.55);
        border-radius: 8px;
      }
    '';
  };
}
