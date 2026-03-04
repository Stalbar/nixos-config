{ pkgs, ... }:

let
  greetdNordBackground = pkgs.runCommand "greetd-regreet-nord-background" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    mkdir -p "$out"

    ${pkgs.imagemagick}/bin/convert -size 1920x1080 gradient:'#748EAD-#2C3A55' \
      -fill '#E5E9F0' -draw "circle 154,112 156,112 circle 290,86 292,86 circle 464,132 466,132 circle 648,94 650,94 circle 806,120 808,120 circle 980,82 982,82 circle 1148,136 1150,136 circle 1316,90 1318,90 circle 1490,124 1492,124 circle 1668,80 1670,80 circle 1822,116 1824,116" \
      -fill 'rgba(188,210,235,0.40)' -draw "polygon 0,690 190,560 420,640 690,520 970,660 1230,540 1490,670 1710,590 1920,700 1920,1080 0,1080" \
      -fill 'rgba(111,135,164,0.55)' -draw "polygon 0,760 260,630 520,740 850,600 1170,760 1450,650 1710,760 1920,680 1920,1080 0,1080" \
      -fill 'rgba(44,58,85,0.84)' -draw "polygon 0,870 320,770 660,860 1010,730 1380,880 1710,760 1920,840 1920,1080 0,1080" \
      "$out/nordic-login.png"
  '';
in
{
  programs.regreet = {
    enable = true;
    cageArgs = [ "-s" "-m" "last" ];

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
      * {
        box-shadow: none;
      }

      window {
        background-image: url("file:///etc/greetd/backgrounds/nordic-login.png");
        background-size: cover;
        background-position: center;
        color: #E5E9F0;
      }

      box, list, grid, row, revealer {
        background: transparent;
      }

      window > box {
        padding: 26px 32px 28px 32px;
      }

      window > box > label {
        font-size: 48px;
        font-weight: 700;
        color: #ECEFF4;
        margin-bottom: 28px;
      }

      #login-window, frame {
        min-width: 460px;
        background: rgba(46, 52, 64, 0.74);
        border: 1px solid rgba(136, 192, 208, 0.34);
        border-radius: 22px;
        padding: 28px;
      }

      label {
        color: #E5E9F0;
      }

      image {
        border-radius: 999px;
      }

      entry {
        min-height: 48px;
        border-radius: 13px;
        background: rgba(59, 66, 82, 0.92);
        color: #ECEFF4;
        border: 1px solid rgba(129, 161, 193, 0.58);
        padding: 0 16px;
        font-size: 20px;
      }

      button {
        min-height: 46px;
        border-radius: 12px;
        background: rgba(94, 129, 172, 0.92);
        color: #ECEFF4;
        border: 1px solid rgba(136, 192, 208, 0.50);
        font-size: 17px;
        font-weight: 600;
        padding: 0 16px;
      }

      button:hover {
        background: rgba(129, 161, 193, 0.96);
      }

      button:active {
        background: rgba(94, 129, 172, 0.98);
      }

      button.suggested-action {
        background: rgba(94, 129, 172, 0.95);
      }

      button.suggested-action:hover {
        background: rgba(129, 161, 193, 0.98);
      }

      combobox, dropdown {
        min-height: 42px;
        border-radius: 12px;
        background: rgba(59, 66, 82, 0.88);
        border: 1px solid rgba(129, 161, 193, 0.45);
        color: #E5E9F0;
      }

      popover {
        background: rgba(46, 52, 64, 0.98);
        border: 1px solid rgba(129, 161, 193, 0.50);
        border-radius: 12px;
      }
    '';
  };

  services.greetd = {
    enable = true;
    greeterManagesPlymouth = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.dbus}/bin/dbus-run-session env GTK_USE_PORTAL=0 GDK_DEBUG=no-portals ${pkgs.cage}/bin/cage -s -m last -- ${pkgs.regreet}/bin/regreet";
      };
    };
  };

  environment.etc."greetd/backgrounds/nordic-login.png".source = "${greetdNordBackground}/nordic-login.png";

  environment.etc."greetd/environments".text = ''
    /etc/profiles/per-user/stalbar/bin/start-hyprland
    bash
    zsh
  '';

  services.getty.helpLine = "";
}
