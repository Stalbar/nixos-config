{ ... }:

let
  mkTheme =
    args:
    let
      mode = args.mode or "dark";
    in
    args
    // {
      inherit mode;
      gtkPreferDark = mode != "light";
      gtkColorScheme = if mode == "light" then "prefer-light" else "prefer-dark";
    };
in
{
  _module.args = {
    nord = {
      nord0 = "2E3440";
      nord1 = "3B4252";
      nord2 = "434C5E";
      nord3 = "4C566A";
      nord4 = "D8DEE9";
      nord5 = "E5E9F0";
      nord6 = "ECEFF4";
      nord7 = "8FBCBB";
      nord8 = "88C0D0";
      nord9 = "81A1C1";
      nord10 = "5E81AC";
      nord11 = "BF616A";
      nord12 = "D08770";
      nord13 = "EBCB8B";
      nord14 = "A3BE8C";
      nord15 = "B48EAD";
    };

    themeOrder = [
      "nord"
      "gruvbox"
      "catppuccin-mocha"
      "kanagawa"
      "rose-pine"
      "onedark"
      "everforest"
      "cyberdream"
      "dracula"
      "solarized"
      "osaka"
      "sonokai"
      "tokyodark"
      "fluoromachine"
      "moonlight"
      "catppuccin-latte"
      "rose-pine-dawn"
      "everforest-light"
      "solarized-light"
      "highcontrast-dark"
      "highcontrast-light"
    ];

    themes = {
      nord = mkTheme {
        id = "nord";
        displayName = "Nord";
        gtkTheme = "Nordic";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "Breeze";
        kdeColorScheme = "Nord";
        nvimTheme = "nord";
        colors = {
          bg0 = "2E3440";
          bg1 = "3B4252";
          bg2 = "434C5E";
          bg3 = "4C566A";
          fg0 = "ECEFF4";
          fg1 = "D8DEE9";
          fg2 = "E5E9F0";
          muted = "4C566A";
          info = "8FBCBB";
          accent = "88C0D0";
          accent2 = "5E81AC";
          accent3 = "81A1C1";
          success = "A3BE8C";
          warning = "EBCB8B";
          error = "BF616A";
          orange = "D08770";
          purple = "B48EAD";
        };
      };

      gruvbox = mkTheme {
        id = "gruvbox";
        displayName = "Gruvbox Material Dark";
        gtkTheme = "Gruvbox-Dark";
        iconTheme = "Gruvbox-Plus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "Breeze";
        kdeColorScheme = "GruvboxMaterialDark";
        nvimTheme = "gruvbox-material";
        colors = {
          bg0 = "282828";
          bg1 = "32302F";
          bg2 = "3A3735";
          bg3 = "504945";
          fg0 = "DDC7A1";
          fg1 = "D4BE98";
          fg2 = "BDAE8B";
          muted = "7C6F64";
          info = "89B482";
          accent = "7DAEA3";
          accent2 = "7DAEA3";
          accent3 = "A9B665";
          success = "A9B665";
          warning = "D8A657";
          error = "EA6962";
          orange = "E78A4E";
          purple = "D3869B";
        };
      };

      catppuccin-mocha = mkTheme {
        id = "catppuccin-mocha";
        displayName = "Catppuccin Mocha";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "CatppuccinMocha";
        nvimTheme = "catppuccin-mocha";
        colors = {
          bg0 = "1E1E2E";
          bg1 = "181825";
          bg2 = "313244";
          bg3 = "45475A";
          fg0 = "F5E0DC";
          fg1 = "CDD6F4";
          fg2 = "BAC2DE";
          muted = "6C7086";
          info = "94E2D5";
          accent = "74C7EC";
          accent2 = "89B4FA";
          accent3 = "B4BEFE";
          success = "A6E3A1";
          warning = "F9E2AF";
          error = "F38BA8";
          orange = "FAB387";
          purple = "CBA6F7";
        };
      };

      kanagawa = mkTheme {
        id = "kanagawa";
        displayName = "Kanagawa";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Kanagawa";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "Kanagawa";
        nvimTheme = "kanagawa";
        colors = {
          bg0 = "1F1F28";
          bg1 = "16161D";
          bg2 = "223249";
          bg3 = "2A2A37";
          fg0 = "DCD7BA";
          fg1 = "DCD7BA";
          fg2 = "C8C093";
          muted = "727169";
          info = "7FB4CA";
          accent = "6A9589";
          accent2 = "7E9CD8";
          accent3 = "658594";
          success = "98BB6C";
          warning = "E6C384";
          error = "E46876";
          orange = "FF9E3B";
          purple = "957FB8";
        };
      };

      rose-pine = mkTheme {
        id = "rose-pine";
        displayName = "Rose Pine";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "rose-pine-moon";
        cursorTheme = "BreezeX-RosePine-Linux";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "RosePine";
        nvimTheme = "rose-pine";
        colors = {
          bg0 = "191724";
          bg1 = "1F1D2E";
          bg2 = "26233A";
          bg3 = "393552";
          fg0 = "F6F3FF";
          fg1 = "E0DEF4";
          fg2 = "908CAA";
          muted = "6E6A86";
          info = "9CCFD8";
          accent = "31748F";
          accent2 = "C4A7E7";
          accent3 = "9CCFD8";
          success = "9CCFD8";
          warning = "F6C177";
          error = "EB6F92";
          orange = "EA9A97";
          purple = "C4A7E7";
        };
      };

      onedark = mkTheme {
        id = "onedark";
        displayName = "OneDark";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "OneDark";
        nvimTheme = "onedark";
        colors = {
          bg0 = "282C34";
          bg1 = "21252B";
          bg2 = "2C313C";
          bg3 = "3E4452";
          fg0 = "E6EAF2";
          fg1 = "ABB2BF";
          fg2 = "5C6370";
          muted = "4B5263";
          info = "56B6C2";
          accent = "61AFEF";
          accent2 = "528BFF";
          accent3 = "98C379";
          success = "98C379";
          warning = "E5C07B";
          error = "E06C75";
          orange = "D19A66";
          purple = "C678DD";
        };
      };

      everforest = mkTheme {
        id = "everforest";
        displayName = "Everforest";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "Everforest";
        nvimTheme = "everforest";
        colors = {
          bg0 = "2D353B";
          bg1 = "343F44";
          bg2 = "3D484D";
          bg3 = "475258";
          fg0 = "E4E1CD";
          fg1 = "D3C6AA";
          fg2 = "9DA9A0";
          muted = "859289";
          info = "7FBBB3";
          accent = "83C092";
          accent2 = "7FBBB3";
          accent3 = "A7C080";
          success = "A7C080";
          warning = "DBBC7F";
          error = "E67E80";
          orange = "E69875";
          purple = "D699B6";
        };
      };

      cyberdream = mkTheme {
        id = "cyberdream";
        displayName = "Cyberdream";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "Cyberdream";
        nvimTheme = "cyberdream";
        colors = {
          bg0 = "16181A";
          bg1 = "1E2124";
          bg2 = "24282C";
          bg3 = "2D3136";
          fg0 = "FFFFFF";
          fg1 = "D7D7D7";
          fg2 = "9EA3A7";
          muted = "5B6065";
          info = "5EF1FF";
          accent = "5EEAD4";
          accent2 = "5EA1FF";
          accent3 = "BD5EFF";
          success = "5EFF6C";
          warning = "FFF38C";
          error = "FF6E5E";
          orange = "FFBD5E";
          purple = "BD5EFF";
        };
      };

      dracula = mkTheme {
        id = "dracula";
        displayName = "Dracula";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Dracula";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "Dracula";
        nvimTheme = "dracula";
        colors = {
          bg0 = "282A36";
          bg1 = "343746";
          bg2 = "44475A";
          bg3 = "6272A4";
          fg0 = "F8F8F2";
          fg1 = "F8F8F2";
          fg2 = "BD93F9";
          muted = "6272A4";
          info = "8BE9FD";
          accent = "8BE9FD";
          accent2 = "BD93F9";
          accent3 = "FF79C6";
          success = "50FA7B";
          warning = "F1FA8C";
          error = "FF5555";
          orange = "FFB86C";
          purple = "FF79C6";
        };
      };

      solarized = mkTheme {
        id = "solarized";
        displayName = "Solarized Dark";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "SolarizedDark";
        nvimTheme = "solarized";
        colors = {
          bg0 = "002B36";
          bg1 = "073642";
          bg2 = "0B3C49";
          bg3 = "586E75";
          fg0 = "FDF6E3";
          fg1 = "93A1A1";
          fg2 = "EEE8D5";
          muted = "657B83";
          info = "2AA198";
          accent = "2AA198";
          accent2 = "268BD2";
          accent3 = "859900";
          success = "859900";
          warning = "B58900";
          error = "DC322F";
          orange = "CB4B16";
          purple = "6C71C4";
        };
      };

      osaka = mkTheme {
        id = "osaka";
        displayName = "Osaka";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "Osaka";
        nvimTheme = "solarized-osaka";
        colors = {
          bg0 = "16161D";
          bg1 = "1F2335";
          bg2 = "24283B";
          bg3 = "414868";
          fg0 = "C0CAF5";
          fg1 = "A9B1D6";
          fg2 = "9AA5CE";
          muted = "565F89";
          info = "7DCFFF";
          accent = "73DACA";
          accent2 = "7AA2F7";
          accent3 = "BB9AF7";
          success = "9ECE6A";
          warning = "E0AF68";
          error = "F7768E";
          orange = "FF9E64";
          purple = "BB9AF7";
        };
      };

      sonokai = mkTheme {
        id = "sonokai";
        displayName = "Sonokai";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "Sonokai";
        nvimTheme = "sonokai";
        colors = {
          bg0 = "2C2E34";
          bg1 = "33353F";
          bg2 = "363944";
          bg3 = "414550";
          fg0 = "E2E2E3";
          fg1 = "E2E2E3";
          fg2 = "A7AAB0";
          muted = "7F8490";
          info = "76CCE0";
          accent = "7DCFFF";
          accent2 = "B39DF3";
          accent3 = "9ED072";
          success = "9ED072";
          warning = "E7C664";
          error = "FC5D7C";
          orange = "F39660";
          purple = "B39DF3";
        };
      };

      tokyodark = mkTheme {
        id = "tokyodark";
        displayName = "TokyoDark";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "TokyoDark";
        nvimTheme = "tokyodark";
        colors = {
          bg0 = "11121D";
          bg1 = "1B1C2B";
          bg2 = "212234";
          bg3 = "2C2D3C";
          fg0 = "C0CAF5";
          fg1 = "A0A8CD";
          fg2 = "8B92B5";
          muted = "565F89";
          info = "2AC3DE";
          accent = "7DCFFF";
          accent2 = "7199EE";
          accent3 = "9ECE6A";
          success = "9ECE6A";
          warning = "E0AF68";
          error = "F7768E";
          orange = "FF9E64";
          purple = "BB9AF7";
        };
      };

      fluoromachine = mkTheme {
        id = "fluoromachine";
        displayName = "Fluoromachine";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "Fluoromachine";
        nvimTheme = "fluoromachine";
        colors = {
          bg0 = "1A1B26";
          bg1 = "23283D";
          bg2 = "2F334D";
          bg3 = "4A4F74";
          fg0 = "FFF9F2";
          fg1 = "D5D7E3";
          fg2 = "BBC0D4";
          muted = "646B8C";
          info = "6AE4FC";
          accent = "00DFFF";
          accent2 = "4D78FF";
          accent3 = "95FFDA";
          success = "95FFA4";
          warning = "FFF272";
          error = "FF7AA2";
          orange = "FFB86C";
          purple = "D5A6FF";
        };
      };

      moonlight = mkTheme {
        id = "moonlight";
        displayName = "Moonlight";
        gtkTheme = "adw-gtk3-dark";
        iconTheme = "Papirus-Dark";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "Moonlight";
        nvimTheme = "moonlight";
        colors = {
          bg0 = "212337";
          bg1 = "2A2E45";
          bg2 = "323652";
          bg3 = "4A4F73";
          fg0 = "E6E9FF";
          fg1 = "C8D3F5";
          fg2 = "A9B8E8";
          muted = "7480B3";
          info = "86E1FC";
          accent = "65BCFF";
          accent2 = "82AAFF";
          accent3 = "FCA7EA";
          success = "C3E88D";
          warning = "FFC777";
          error = "FF757F";
          orange = "FF966C";
          purple = "FCA7EA";
        };
      };

      "catppuccin-latte" = mkTheme {
        id = "catppuccin-latte";
        displayName = "Catppuccin Latte";
        mode = "light";
        gtkTheme = "adw-gtk3";
        iconTheme = "Papirus";
        cursorTheme = "Bibata-Modern-Classic";
        qtStyle = "adwaita";
        kdeColorScheme = "CatppuccinLatte";
        nvimTheme = "catppuccin-latte";
        colors = {
          bg0 = "EFF1F5";
          bg1 = "E6E9EF";
          bg2 = "CCD0DA";
          bg3 = "BCC0CC";
          fg0 = "313244";
          fg1 = "45475A";
          fg2 = "5C5F77";
          muted = "7C7F93";
          info = "179299";
          accent = "04A5E5";
          accent2 = "1E66F5";
          accent3 = "8839EF";
          success = "40A02B";
          warning = "DF8E1D";
          error = "D20F39";
          orange = "FE640B";
          purple = "8839EF";
        };
      };

      "rose-pine-dawn" = mkTheme {
        id = "rose-pine-dawn";
        displayName = "Rose Pine Dawn";
        mode = "light";
        gtkTheme = "adw-gtk3";
        iconTheme = "rose-pine-dawn";
        cursorTheme = "BreezeX-RosePineDawn-Linux";
        qtStyle = "adwaita";
        kdeColorScheme = "RosePineDawn";
        nvimTheme = "rose-pine-dawn";
        colors = {
          bg0 = "FAF4ED";
          bg1 = "FFF8F0";
          bg2 = "F2E9E1";
          bg3 = "DFDAD9";
          fg0 = "433C67";
          fg1 = "575279";
          fg2 = "6E6A86";
          muted = "86819A";
          info = "286983";
          accent = "56949F";
          accent2 = "7E6A94";
          accent3 = "D7827E";
          success = "56949F";
          warning = "EA9D34";
          error = "B4637A";
          orange = "D7827E";
          purple = "907AA9";
        };
      };

      "everforest-light" = mkTheme {
        id = "everforest-light";
        displayName = "Everforest Light";
        mode = "light";
        gtkTheme = "adw-gtk3";
        iconTheme = "Papirus";
        cursorTheme = "Bibata-Modern-Classic";
        qtStyle = "adwaita";
        kdeColorScheme = "EverforestLight";
        nvimTheme = "everforest-light";
        colors = {
          bg0 = "FDF6E3";
          bg1 = "F4EFD8";
          bg2 = "EDE6CF";
          bg3 = "D3C6AA";
          fg0 = "475258";
          fg1 = "56635F";
          fg2 = "66756F";
          muted = "788680";
          info = "3A94C5";
          accent = "35A77C";
          accent2 = "4C6A92";
          accent3 = "8DA101";
          success = "8DA101";
          warning = "DFA000";
          error = "F85552";
          orange = "F57D26";
          purple = "DF69BA";
        };
      };

      "solarized-light" = mkTheme {
        id = "solarized-light";
        displayName = "Solarized Light";
        mode = "light";
        gtkTheme = "adw-gtk3";
        iconTheme = "Papirus";
        cursorTheme = "Bibata-Modern-Classic";
        qtStyle = "adwaita";
        kdeColorScheme = "SolarizedLight";
        nvimTheme = "solarized-light";
        colors = {
          bg0 = "FDF6E3";
          bg1 = "EEE8D5";
          bg2 = "E4DDC7";
          bg3 = "93A1A1";
          fg0 = "073642";
          fg1 = "465A61";
          fg2 = "586E75";
          muted = "657B83";
          info = "2AA198";
          accent = "268BD2";
          accent2 = "6C71C4";
          accent3 = "859900";
          success = "859900";
          warning = "B58900";
          error = "DC322F";
          orange = "CB4B16";
          purple = "6C71C4";
        };
      };

      "highcontrast-dark" = mkTheme {
        id = "highcontrast-dark";
        displayName = "High Contrast Dark";
        gtkTheme = "HighContrastInverse";
        iconTheme = "hicolor";
        cursorTheme = "Bibata-Modern-Ice";
        qtStyle = "adwaita-dark";
        kdeColorScheme = "HighContrastDark";
        nvimTheme = "highcontrast-dark";
        colors = {
          bg0 = "000000";
          bg1 = "111111";
          bg2 = "1C1C1C";
          bg3 = "FFFFFF";
          fg0 = "FFFFFF";
          fg1 = "F2F2F2";
          fg2 = "D0D0D0";
          muted = "A0A0A0";
          info = "00FFFF";
          accent = "00BFFF";
          accent2 = "FFD700";
          accent3 = "7CFC00";
          success = "7CFC00";
          warning = "FFD700";
          error = "FF4D4D";
          orange = "FF8C00";
          purple = "DA70D6";
        };
      };

      "highcontrast-light" = mkTheme {
        id = "highcontrast-light";
        displayName = "High Contrast Light";
        mode = "light";
        gtkTheme = "HighContrast";
        iconTheme = "hicolor";
        cursorTheme = "Bibata-Modern-Classic";
        qtStyle = "adwaita";
        kdeColorScheme = "HighContrastLight";
        nvimTheme = "highcontrast-light";
        colors = {
          bg0 = "FFFFFF";
          bg1 = "F2F2F2";
          bg2 = "E0E0E0";
          bg3 = "000000";
          fg0 = "000000";
          fg1 = "111111";
          fg2 = "303030";
          muted = "666666";
          info = "005FCC";
          accent = "0066FF";
          accent2 = "7A00CC";
          accent3 = "008A00";
          success = "008A00";
          warning = "A05A00";
          error = "CC0000";
          orange = "CC5500";
          purple = "7A00CC";
        };
      };
    };
  };
}
