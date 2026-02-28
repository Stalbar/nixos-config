{ pkgs, nord, ... }:

let
  volumeScript = pkgs.writeShellApplication {
    name = "volume";
    runtimeInputs = with pkgs; [ pamixer dunst ];
    text = ''
      set -euo pipefail

      notify_volume() {
        local volume muted icon
        volume="$(pamixer --get-volume)"
        muted="$(pamixer --get-mute)"

        if [ "$muted" = "true" ]; then
          dunstify \
            -a "volume" \
            -u low \
            -i audio-volume-muted-symbolic \
            -h string:x-dunst-stack-tag:volume \
            "Volume" "Muted"
          return
        fi

        if [ "$volume" -lt 34 ]; then
          icon="audio-volume-low-symbolic"
        elif [ "$volume" -lt 67 ]; then
          icon="audio-volume-medium-symbolic"
        else
          icon="audio-volume-high-symbolic"
        fi

        dunstify \
          -a "volume" \
          -u low \
          -i "$icon" \
          -h int:value:"$volume" \
          -h string:x-dunst-stack-tag:volume \
          "Volume" "$volume%"
      }

      toggle_volume_mute() {
        pamixer -t
        notify_volume
      }

      toggle_mic_mute() {
        local muted
        pamixer --default-source -t
        muted="$(pamixer --default-source --get-mute)"
        if [ "$muted" = "true" ]; then
          dunstify \
            -a "microphone" \
            -u low \
            -i microphone-sensitivity-muted-symbolic \
            -h string:x-dunst-stack-tag:microphone \
            "Microphone" "Muted"
        else
          dunstify \
            -a "microphone" \
            -u low \
            -i microphone-sensitivity-high-symbolic \
            -h string:x-dunst-stack-tag:microphone \
            "Microphone" "Enabled"
        fi
      }

      case "''${1:-}" in
        --inc)
          pamixer -i 2
          notify_volume
          ;;
        --dec)
          pamixer -d 2
          notify_volume
          ;;
        --mute-volume)
          toggle_volume_mute
          ;;
        --mute-mic)
          toggle_mic_mute
          ;;
        *)
          echo "Usage: volume [--inc|--dec|--mute-volume|--mute-mic]" >&2
          exit 2
          ;;
      esac
    '';
  };

  brightnessScript = pkgs.writeShellApplication {
    name = "brightness";
    runtimeInputs = with pkgs; [ brightnessctl dunst gnused coreutils ];
    text = ''
      set -euo pipefail

      notify_brightness() {
        local percent
        percent="$(brightnessctl -m | sed -n 's/.*,\([0-9]\+%\),.*/\1/p')"
        percent="''${percent%%%}"
        if [ -z "$percent" ]; then
          percent=0
        fi

        dunstify \
          -a "brightness" \
          -u low \
          -i display-brightness-symbolic \
          -h int:value:"$percent" \
          -h string:x-dunst-stack-tag:brightness \
          "Brightness" "$percent%"
      }

      case "''${1:-}" in
        --inc)
          brightnessctl set 5%+
          notify_brightness
          ;;
        --dec)
          brightnessctl set 5%-
          notify_brightness
          ;;
        *)
          echo "Usage: brightness [--inc|--dec]" >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  home.packages = [
    volumeScript
    brightnessScript
  ];

  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
      size = "32x32";
    };
    settings = {
      global = {
        monitor = 0;
        follow = "none";
        origin = "bottom-right";
        offset = "(16,16)";
        width = "(260,340)";
        height = "(0,220)";
        notification_limit = 5;
        padding = 10;
        horizontal_padding = 12;
        text_icon_padding = 10;
        separator_height = 0;
        frame_width = 1;
        corner_radius = 10;
        font = "JetBrainsMono Nerd Font Mono 10";
        markup = "full";
        alignment = "left";
        vertical_alignment = "center";
        ellipsize = "middle";
        icon_position = "left";
        min_icon_size = 28;
        max_icon_size = 48;
        enable_recursive_icon_lookup = true;
        progress_bar = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 110;
        progress_bar_max_width = 250;
        progress_bar_corner_radius = 4;
        transparency = 8;
        background = "#${nord.nord0}";
        foreground = "#${nord.nord4}";
        frame_color = "#${nord.nord3}";
        separator_color = "frame";
        highlight = "#${nord.nord10}";
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        background = "#${nord.nord0}";
        foreground = "#${nord.nord4}";
        frame_color = "#${nord.nord3}";
        highlight = "#${nord.nord10}";
        timeout = 3;
      };

      urgency_normal = {
        background = "#${nord.nord0}";
        foreground = "#${nord.nord4}";
        frame_color = "#${nord.nord9}";
        highlight = "#${nord.nord8}";
        timeout = 5;
      };

      urgency_critical = {
        background = "#${nord.nord0}";
        foreground = "#${nord.nord6}";
        frame_color = "#${nord.nord11}";
        highlight = "#${nord.nord11}";
        timeout = 0;
      };
    };
  };
}
