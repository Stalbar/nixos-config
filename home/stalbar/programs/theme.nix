{ lib, pkgs, ... }:

{
  dconf.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Nordic";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Ice";
      font-name = "JetBrainsMono Nerd Font Mono 11";
      monospace-font-name = "JetBrainsMono Nerd Font Mono 11";
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  xdg.dataFile."color-schemes/Nord.colors".text = ''
    [ColorEffects:Disabled]
    Color=49,52,63
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.56
    ContrastEffect=1
    IntensityAmount=0.10
    IntensityEffect=2

    [ColorEffects:Inactive]
    Color=49,52,63
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.56
    ContrastEffect=1
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=59,66,82
    BackgroundNormal=67,76,94
    DecorationFocus=129,161,193
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=76,86,106
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=216,222,233
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Complementary]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=129,161,193
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=76,86,106
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=216,222,233
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Selection]
    BackgroundAlternate=129,161,193
    BackgroundNormal=94,129,172
    DecorationFocus=129,161,193
    DecorationHover=136,192,208
    ForegroundActive=236,239,244
    ForegroundInactive=216,222,233
    ForegroundLink=236,239,244
    ForegroundNegative=236,239,244
    ForegroundNeutral=236,239,244
    ForegroundNormal=236,239,244
    ForegroundPositive=236,239,244
    ForegroundVisited=229,233,240

    [Colors:Tooltip]
    BackgroundAlternate=59,66,82
    BackgroundNormal=67,76,94
    DecorationFocus=129,161,193
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=76,86,106
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=216,222,233
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:View]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=129,161,193
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=76,86,106
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=216,222,233
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Window]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=129,161,193
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=76,86,106
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=216,222,233
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [General]
    ColorScheme=Nord
    Name=Nord
    shadeSortColumn=true

    [KDE]
    contrast=4

    [WM]
    activeBackground=94,129,172
    activeForeground=236,239,244
    inactiveBackground=59,66,82
    inactiveForeground=216,222,233
  '';

  xdg.configFile."kdeglobals".text = ''
    [General]
    ColorScheme=Nord
    Name=Nord

    [KDE]
    widgetStyle=Breeze
  '';

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    GTK_THEME = "Nordic";
    QT_QPA_PLATFORMTHEME = "gtk3";
    KDE_COLOR_SCHEME = "Nord";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  home.activation.okularNordScheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    okular_rc="$HOME/.config/okularrc"
    mkdir -p "$HOME/.config"

    if [ -f "$okular_rc" ]; then
      if grep -q '^ColorScheme=' "$okular_rc"; then
        sed -i 's/^ColorScheme=.*/ColorScheme=Nord/' "$okular_rc"
      else
        printf '\n[UiSettings]\nColorScheme=Nord\n' >> "$okular_rc"
      fi
    else
      cat > "$okular_rc" <<'EOF'
[UiSettings]
ColorScheme=Nord
EOF
    fi
  '';
}
