{ config, pkgs, ... }:
let
  launch-waybar = pkgs.writeShellScriptBin "launch-waybar" ''
    CONFIG_FILES="${config.xdg.configHome}/waybar/config"
    STYLE_FILE="${config.xdg.configHome}/waybar/style.css"

    trap "killall .waybar-wrapped" EXIT

    while true; do
      ${pkgs.waybar}/bin/waybar &
      
      ${pkgs.inotify-tools}/bin/inotifywait -e create,modify $CONFIG_FILES $STYLE_FILE
      
      killall .waybar-wrapped
    done
  '';
in
{
  home.packages = [ launch-waybar ];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        height = 40;
        margin-left = 0;
        margin-right = 0;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "group/time" ];
        modules-right = [ "privacy" "hyprland/language" "group/zvuk" "group/hardware" "tray" "network" ];

        "hyprland/window" = {
          format = "{initialTitle}";
          max-length = 35;
          rewrite = { "" = "Hyprland"; "kitty" = "Terminal"; };
        };

        "hyprland/language" = {
          format = "<span color=\"#f6c177\"></span>  {}"; # Gold
          format-en = "EN";
          format-ru = "RU";
        };

        "hyprland/workspaces" = {
          on-click = "activate";
          sort-by-number = true;
          persistent-workspaces = { "1" = "1"; "2" = "2"; "3" = "3"; "4" = "4"; "5" = "5"; "6" = "6"; };
        };

        "group/hardware" = {
          orientation = "horizontal";
          modules = [ "cpu" "memory" "battery" ];
        };

        cpu = { format = "<span color=\"#ebbcba\"></span>  {usage}%"; tooltip = false; }; # Rose
        memory = { format = "<span color=\"#9ccfd8\"></span>  {percentage}% "; }; # Foam
        battery = {
          format = "<span color=\"#f6c177\">{icon}</span> {capacity}%"; # Gold
          format-icons = [ " " " " " " " " " " ];
        };

        "group/zvuk" = {
          orientation = "horizontal";
          modules = [ "pulseaudio#output" "pulseaudio#input" ];
        };

        "pulseaudio#output" = {
          format = "<span color=\"#31748f\">{icon}</span> {volume}%"; # Pine
          format-muted = " ";
          format-icons = { headphone = ""; default = [ " " " " " " ]; };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "pulseaudio#input" = {
          format = "<span color=\"#31748f\"></span>  {volume}%";
          format-source-muted = " ";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        "group/time" = { modules = [ "clock" "clock#simple" ]; orientation = "horizontal"; };
        "clock#simple" = { format = "{:%H:%M:%S}"; tooltip = false; interval = 1; };
        clock = {
          format = "{:L%a %d, %b %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        network = {
          format-wifi = "<span color=\"#f6c177\"> </span>";
          format-ethernet = "<span color=\"#f6c177\"> </span>";
          format-disconnected = "⚠";
          tooltip = false;
        };
        tray = { spacing = 10; };
      };
    };
    style = ''
      /* --- ROSE PINE COLOR PALETTE --- */
      @define-color background      #1f1d2e; /* Base */
      @define-color foreground      #e0def4; /* Text */
      @define-color foreground-dark #908caa; /* Subtle */
      @define-color power           #eb6f92; /* Love (Red/Pink) */
      @define-color red             #eb6f92; /* Love */
      @define-color orange          #f6c177; /* Gold */
      @define-color overlay         #26233a; /* Surface */
      @define-color pine            #31748f; /* Pine (Accent) */
      @define-color foam            #9ccfd8; /* Foam (Accent) */

      /* --- GLOBAL STYLES --- */
      * {
        font-family: "JetBrains Mono NerdFont", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        font-size: 1.01em;
      }

      window#waybar {
        background-color: transparent;
        border-radius: 0;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      window#waybar > box {
        padding: 5px 0;
      }

      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 10px;
      }

      button:hover {
        background: inherit;
        border: none;
      }

      /* --- WORKSPACES --- */
      #workspaces {
        font-weight: 800;
        margin-right: 5px;
        background-color: @background;
        color: @foreground;
        border-radius: 10px;
      }

      #workspaces button {
        border-radius: 10px;
        padding: 0 8px;
        color: @foreground-dark;
        background-color: transparent;
        transition: 0.5s ease-out;
      }

      #workspaces button:hover {
        background: rgba(224, 222, 244, 0.1);
      }

      #workspaces button.active {
        background-color: @pine; 
        color: @background;
      }

      #workspaces button.active:nth-child(1) { border-radius: 10px 0 0 10px; }
      #workspaces button.active:nth-last-child(1) { border-radius: 0 10px 10px 0; }

      #workspaces button.urgent {
        border-bottom: 2px solid @red;
        border-radius: 0;
      }

      /* --- HARDWARE --- */
      #hardware { margin-right: 5px; }
      #cpu { padding-right: 10px; }
      #memory { padding-left: 10px; }

      /* --- AUDIO (ZVUK) --- */
      #zvuk {
        background-color: @background;
        color: @foreground;
        border-radius: 10px;
        margin-right: 5px;
      }

      #pulseaudio:hover { background-color: @overlay; }
      #pulseaudio {
        font-weight: 700;
        padding: 6px 10px;
        border-radius: 10px;
      }

      #pulseaudio.output.muted, #pulseaudio.input.source-muted {
        color: @red;
      }

      /* --- PRIVACY & LANGUAGE --- */
      #privacy {
        background-color: @background;
        color: @power;
        border: 1.5px solid @power;
        padding: 6px 10px;
        border-radius: 10px;
        margin-right: 10px;
      }

      #language { margin-right: 5px; }

      /* --- TIME & CLOCK --- */
      #time {
        border-radius: 10px;
        font-weight: 700;
        background-color: @background;
        color: @foreground;
      }

      #clock.simple {
        padding: 6px 10px;
        background-color: @orange; /* Gold Accent */
        color: @background;
        border-radius: 0 10px 10px 0;
        font-weight: 700;
      }

      #clock {
        padding: 6px 10px;
        border-radius: 10px 0 0 10px;
      }

      /* --- TRAY & SYSTEM --- */
      #tray { margin-right: 5px; }
      #tray > .passive { -gtk-icon-effect: dim; }
      #tray > .needs-attention { -gtk-icon-effect: highlight; }

      #battery,
      #temperature,
      #network,
      #hardware,
      #window,
      #tray,
      #language {
        font-weight: 700;
        background-color: @background;
        color: @foreground;
        padding: 6px 10px;
        border-radius: 10px;
      }

      .modules-right, .modules-left { padding: 0 10px; }
      label:focus { background-color: #000; }
    '';
  };
}

