{ pkgs, ... }:

let
  nord = (import ../../home/stalbar/theme/nord.nix { })._module.args.nord;
  hex = name: "#${nord.${name}}";
  hyprlandLuaSession = pkgs.writeShellScriptBin "start-hyprland-lua" ''
    exec ${pkgs.hyprland}/bin/Hyprland --config "$HOME/.config/hypr/hyprland.lua"
  '';

  greetdNordBackground =
    pkgs.runCommand "greetd-regreet-nord-background" { nativeBuildInputs = [ pkgs.imagemagick ]; }
      ''
        mkdir -p "$out"

        ${pkgs.imagemagick}/bin/convert -size 1920x1080 gradient:'${hex "nord9"}-${hex "nord1"}' \
          -fill '${hex "nord6"}' -draw "circle 154,112 156,112 circle 290,86 292,86 circle 464,132 466,132 circle 648,94 650,94 circle 806,120 808,120 circle 980,82 982,82 circle 1148,136 1150,136 circle 1316,90 1318,90 circle 1490,124 1492,124 circle 1668,80 1670,80 circle 1822,116 1824,116" \
          -fill '${hex "nord5"}66' -draw "polygon 0,690 190,560 420,640 690,520 970,660 1230,540 1490,670 1710,590 1920,700 1920,1080 0,1080" \
          -fill '${hex "nord9"}88' -draw "polygon 0,760 260,630 520,740 850,600 1170,760 1450,650 1710,760 1920,680 1920,1080 0,1080" \
          -fill '${hex "nord1"}d6' -draw "polygon 0,870 320,770 660,860 1010,730 1380,880 1710,760 1920,840 1920,1080 0,1080" \
          "$out/nordic-login.png"
      '';
in
{
  environment.systemPackages = [ hyprlandLuaSession ];

  programs.regreet = {
    enable = true;
    cageArgs = [
      "-s"
      "-m"
      "extend"
    ];

    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
    };

    settings = {
      background = {
        path = "/etc/greetd/backgrounds/nordic-login.png";
        fit = "Cover";
      };

      appearance = {
        greeting_msg = "Welcome to greetd";
      };

      widget.clock = {
        format = "";
        resolution = "1000ms";
        label_width = 0;
      };

      GTK = {
        application_prefer_dark_theme = true;
        cursor_blink = false;
      };
    };

    extraCss = ''
      @define-color nord0 ${hex "nord0"};
      @define-color nord1 ${hex "nord1"};
      @define-color nord2 ${hex "nord2"};
      @define-color nord3 ${hex "nord3"};
      @define-color nord4 ${hex "nord4"};
      @define-color nord5 ${hex "nord5"};
      @define-color nord6 ${hex "nord6"};
      @define-color nord8 ${hex "nord8"};
      @define-color nord9 ${hex "nord9"};
      @define-color nord10 ${hex "nord10"};

      * {
        box-shadow: none;
        text-shadow: none;
      }

      window,
      window.background {
        background-color: @nord0;
        background-image: url("file:///etc/greetd/backgrounds/nordic-login.png");
        background-size: cover;
        background-position: center;
        color: @nord4;
      }

      window > box {
        padding: 26px 32px 28px 32px;
      }

      window > box > label {
        font-size: 48px;
        font-weight: 700;
        color: @nord6;
        margin-bottom: 28px;
      }

      #login-window, frame {
        min-width: 460px;
        background-color: alpha(@nord0, 0.92);
        border: 1px solid alpha(@nord8, 0.50);
        border-radius: 12px;
        padding: 28px;
      }

      label {
        color: @nord4;
      }

      image {
        border-radius: 999px;
      }

      entry {
        min-height: 48px;
        border-radius: 8px;
        background-color: @nord1;
        color: @nord6;
        border: 1px solid alpha(@nord9, 0.70);
        padding: 0 16px;
        font-size: 20px;
      }

      button {
        min-height: 46px;
        border-radius: 8px;
        background-color: @nord10;
        color: @nord6;
        border: 1px solid alpha(@nord8, 0.60);
        font-size: 17px;
        font-weight: 600;
        padding: 0 16px;
      }

      button:hover {
        background-color: @nord9;
      }

      button:active {
        background-color: @nord10;
      }

      button.suggested-action {
        background-color: @nord10;
      }

      button.suggested-action:hover {
        background-color: @nord9;
      }

      combobox, dropdown {
        min-height: 42px;
        border-radius: 8px;
        background-color: @nord1;
        border: 1px solid alpha(@nord9, 0.60);
        color: @nord4;
      }

      popover {
        background-color: @nord0;
        border: 1px solid alpha(@nord9, 0.60);
        border-radius: 8px;
      }
    '';
  };

  services.greetd = {
    enable = true;
    greeterManagesPlymouth = true;
    settings.default_session.user = "greeter";
  };

  environment.etc."greetd/backgrounds/nordic-login.png".source =
    "${greetdNordBackground}/nordic-login.png";

  environment.etc."greetd/environments".text = ''
    ${hyprlandLuaSession}/bin/start-hyprland-lua
    bash
    zsh
  '';

  services.getty.helpLine = "";
}
