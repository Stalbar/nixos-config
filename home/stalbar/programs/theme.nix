{
  config,
  lib,
  pkgs,
  themeOrder,
  themes,
  ...
}:

let
  homeDir = config.home.homeDirectory;
  themeStateDir = "${homeDir}/.config/stalbar-theme";
  generatedThemeDir = "${themeStateDir}/generated";
  themeIds = builtins.filter (id: builtins.hasAttr id themes) themeOrder;
  themeList = builtins.map (id: themes.${id}) themeIds;
  themeNamesText = lib.concatStringsSep "|" themeIds;

  alphaHex = alpha: hex: "#${alpha}${hex}";
  hexValues = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "A" = 10;
    "B" = 11;
    "C" = 12;
    "D" = 13;
    "E" = 14;
    "F" = 15;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
  };
  hexNibble =
    digit:
    hexValues.${digit} or (throw "Unsupported hex color digit: ${digit}");
  hexByte =
    hex: offset:
    (hexNibble (builtins.substring offset 1 hex)) * 16
    + hexNibble (builtins.substring (offset + 1) 1 hex);
  hexToRgb =
    hex:
    "${toString (hexByte hex 0)},${toString (hexByte hex 2)},${toString (hexByte hex 4)}";

  mkKdeColors =
    theme:
    let
      c = theme.colors;
      rgb = hexToRgb;
    in
    ''
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
      BackgroundAlternate=60,56,54
      BackgroundNormal=${rgb c.bg2}
      DecorationFocus=${rgb c.accent3}
      DecorationHover=${rgb c.accent}
      ForegroundActive=${rgb c.accent}
      ForegroundInactive=${rgb c.muted}
      ForegroundLink=${rgb c.accent}
      ForegroundNegative=${rgb c.error}
      ForegroundNeutral=${rgb c.warning}
      ForegroundNormal=${rgb c.fg1}
      ForegroundPositive=${rgb c.success}
      ForegroundVisited=${rgb c.purple}

      [Colors:Complementary]
      BackgroundAlternate=59,66,82
      BackgroundNormal=${rgb c.bg0}
      DecorationFocus=${rgb c.accent3}
      DecorationHover=${rgb c.accent}
      ForegroundActive=${rgb c.accent}
      ForegroundInactive=${rgb c.muted}
      ForegroundLink=${rgb c.accent}
      ForegroundNegative=${rgb c.error}
      ForegroundNeutral=${rgb c.warning}
      ForegroundNormal=${rgb c.fg1}
      ForegroundPositive=${rgb c.success}
      ForegroundVisited=${rgb c.purple}

      [Colors:Selection]
      BackgroundAlternate=${rgb c.accent3}
      BackgroundNormal=${rgb c.accent2}
      DecorationFocus=${rgb c.accent3}
      DecorationHover=${rgb c.accent}
      ForegroundActive=${rgb c.fg0}
      ForegroundInactive=${rgb c.fg1}
      ForegroundLink=${rgb c.fg0}
      ForegroundNegative=${rgb c.fg0}
      ForegroundNeutral=${rgb c.fg0}
      ForegroundNormal=${rgb c.fg0}
      ForegroundPositive=${rgb c.fg0}
      ForegroundVisited=${rgb c.fg2}

      [Colors:Tooltip]
      BackgroundAlternate=59,66,82
      BackgroundNormal=${rgb c.bg1}
      DecorationFocus=${rgb c.accent3}
      DecorationHover=${rgb c.accent}
      ForegroundActive=${rgb c.accent}
      ForegroundInactive=${rgb c.muted}
      ForegroundLink=${rgb c.accent}
      ForegroundNegative=${rgb c.error}
      ForegroundNeutral=${rgb c.warning}
      ForegroundNormal=${rgb c.fg1}
      ForegroundPositive=${rgb c.success}
      ForegroundVisited=${rgb c.purple}

      [Colors:View]
      BackgroundAlternate=${rgb c.bg1}
      BackgroundNormal=${rgb c.bg0}
      DecorationFocus=${rgb c.accent3}
      DecorationHover=${rgb c.accent}
      ForegroundActive=${rgb c.accent}
      ForegroundInactive=${rgb c.muted}
      ForegroundLink=${rgb c.accent}
      ForegroundNegative=${rgb c.error}
      ForegroundNeutral=${rgb c.warning}
      ForegroundNormal=${rgb c.fg1}
      ForegroundPositive=${rgb c.success}
      ForegroundVisited=${rgb c.purple}

      [Colors:Window]
      BackgroundAlternate=${rgb c.bg1}
      BackgroundNormal=${rgb c.bg0}
      DecorationFocus=${rgb c.accent3}
      DecorationHover=${rgb c.accent}
      ForegroundActive=${rgb c.accent}
      ForegroundInactive=${rgb c.muted}
      ForegroundLink=${rgb c.accent}
      ForegroundNegative=${rgb c.error}
      ForegroundNeutral=${rgb c.warning}
      ForegroundNormal=${rgb c.fg1}
      ForegroundPositive=${rgb c.success}
      ForegroundVisited=${rgb c.purple}

      [General]
      ColorScheme=${theme.kdeColorScheme}
      Name=${theme.kdeColorScheme}
      shadeSortColumn=true

      [KDE]
      contrast=4

      [WM]
      activeBackground=${rgb c.accent2}
      activeForeground=${rgb c.fg0}
      inactiveBackground=${rgb c.bg1}
      inactiveForeground=${rgb c.fg1}
    '';

  mkKdeGlobals = theme: ''
    [General]
    ColorScheme=${theme.kdeColorScheme}
    Name=${theme.kdeColorScheme}

    [KDE]
    widgetStyle=${theme.qtStyle}
  '';

  mkGtkSettings = theme: ''
    [Settings]
    gtk-application-prefer-dark-theme=${if theme.gtkPreferDark then "1" else "0"}
    gtk-theme-name=${theme.gtkTheme}
    gtk-icon-theme-name=${theme.iconTheme}
    gtk-cursor-theme-name=${theme.cursorTheme}
    gtk-cursor-theme-size=24
    gtk-font-name=JetBrainsMono Nerd Font Mono 11
  '';

  mkGtkCss =
    theme:
    let
      c = theme.colors;
    in
    ''
      @define-color accent_color #${c.accent};
      @define-color accent_bg_color #${c.accent2};
      @define-color accent_fg_color #${c.fg0};
      @define-color destructive_color #${c.error};
      @define-color success_color #${c.success};
      @define-color warning_color #${c.warning};

      @define-color window_bg_color #${c.bg0};
      @define-color window_fg_color #${c.fg1};
      @define-color view_bg_color #${c.bg0};
      @define-color view_fg_color #${c.fg1};
      @define-color headerbar_bg_color #${c.bg1};
      @define-color headerbar_fg_color #${c.fg1};
      @define-color card_bg_color #${c.bg1};
      @define-color card_fg_color #${c.fg1};
      @define-color popover_bg_color #${c.bg1};
      @define-color popover_fg_color #${c.fg1};
      @define-color sidebar_bg_color #${c.bg1};
      @define-color sidebar_fg_color #${c.fg1};
      @define-color border_color #${c.bg3};

      window,
      dialog,
      popover,
      menu,
      .background {
        color: @window_fg_color;
        background-color: @window_bg_color;
      }

      headerbar,
      .titlebar,
      .navigation-sidebar {
        color: @headerbar_fg_color;
        background-image: none;
        background-color: @headerbar_bg_color;
        border-color: @border_color;
        box-shadow: none;
      }

      button,
      entry,
      spinbutton,
      combobox box,
      textview,
      list row,
      row,
      scrollbar slider,
      progressbar trough,
      scale trough {
        background-image: none;
        box-shadow: none;
      }

      button,
      entry,
      spinbutton,
      combobox box,
      textview,
      list row,
      row {
        color: @window_fg_color;
        background-color: @card_bg_color;
        border: 1px solid @border_color;
        border-radius: 10px;
      }

      button:hover,
      row:hover,
      list row:hover,
      entry:hover,
      textview:hover {
        background-color: #${c.bg2};
      }

      button:checked,
      button:active,
      button:selected,
      row:selected,
      list row:selected,
      calendar:selected {
        color: @accent_fg_color;
        background-color: @accent_bg_color;
      }

      selection,
      *:selected {
        color: @accent_fg_color;
        background-color: @accent_bg_color;
      }

      tooltip,
      popover contents,
      menu {
        color: @popover_fg_color;
        background-color: @popover_bg_color;
        border: 1px solid @border_color;
      }
    '';

  mkQtctConf = theme: ''
    [Appearance]
    color_scheme_path=
    custom_palette=false
    icon_theme=${theme.iconTheme}
    standard_dialogs=default
    style=${theme.qtStyle}

    [Fonts]
    fixed="JetBrainsMono Nerd Font Mono,11,-1,5,50,0,0,0,0,0"
    general="JetBrainsMono Nerd Font Mono,11,-1,5,50,0,0,0,0,0"

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    dialog_buttons_have_icons=1
    menus_have_icons=true
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3
  '';

  mkStarshipConfig =
    theme:
    let
      c = theme.colors;
    in
    ''
      add_newline = true
      command_timeout = 500
      scan_timeout = 20
      palette = "runtime"

      format = """
      $os$directory$git_branch$git_status$fill$time
      $character
      """

      [palettes.runtime]
      accent = "#${c.accent}"
      accent2 = "#${c.accent2}"
      accent3 = "#${c.accent3}"
      info = "#${c.info}"
      success = "#${c.success}"
      warning = "#${c.warning}"
      error = "#${c.error}"
      purple = "#${c.purple}"

      [os]
      disabled = false
      style = "bold fg:accent"
      format = "[$symbol ]($style)"

      [os.symbols]
      NixOS = ""

      [directory]
      style = "bold fg:accent2"
      format = "[$path ]($style)"
      truncation_length = 5
      truncation_symbol = ""

      [git_branch]
      symbol = ""
      style = "bold fg:info"
      format = "[$symbol $branch ]($style)"

      [git_status]
      style = "bold fg:info"
      format = "[$all_status$ahead_behind ]($style)"
      conflicted = "󰕚 "
      ahead = "󰜷 "
      behind = "󰜮 "
      diverged = "󰃻 "
      up_to_date = ""
      untracked = "󰞋 "
      stashed = "󰏗 "
      modified = "󰏫 "
      staged = "󰐗 "
      renamed = "󰏪 "
      deleted = "󰍶 "

      [c]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [dart]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [dotnet]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [golang]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [java]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [lua]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [nodejs]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [php]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [python]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [rust]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [zig]
      symbol = " "
      style = "bold fg:accent3"
      format = "[$symbol($version) ]($style)"

      [fill]
      symbol = " "

      [time]
      disabled = false
      time_format = "%H:%M"
      style = "bold fg:accent"
      format = "[ $time ]($style)"

      [character]
      success_symbol = "[❯](bold fg:accent)"
      error_symbol = "[❯](bold fg:error)"
      vimcmd_symbol = "[❮](bold fg:accent)"
      vimcmd_replace_one_symbol = "[❮](bold fg:purple)"
      vimcmd_replace_symbol = "[❮](bold fg:purple)"
      vimcmd_visual_symbol = "[❮](bold fg:warning)"
    '';

  mkZshTheme =
    theme:
    let
      c = theme.colors;
    in
    ''
      # Generated by switch-theme. Do not edit by hand.
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#${c.fg2},italic'

      typeset -gA ZSH_HIGHLIGHT_STYLES
      ZSH_HIGHLIGHT_STYLES[default]='fg=#${c.fg0}'
      ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#${c.error},bold'
      ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#${c.purple},bold'
      ZSH_HIGHLIGHT_STYLES[alias]='fg=#${c.accent}'
      ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#${c.accent}'
      ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#${c.accent},bold'
      ZSH_HIGHLIGHT_STYLES[builtin]='fg=#${c.accent3}'
      ZSH_HIGHLIGHT_STYLES[function]='fg=#${c.success}'
      ZSH_HIGHLIGHT_STYLES[command]='fg=#${c.accent}'
      ZSH_HIGHLIGHT_STYLES[precommand]='fg=#${c.warning}'
      ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#${c.fg2}'
      ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#${c.accent}'
      ZSH_HIGHLIGHT_STYLES[path]='fg=#${c.info},underline'
      ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#${c.fg2}'
      ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#${c.info}'
      ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#${c.fg2}'
      ZSH_HIGHLIGHT_STYLES[globbing]='fg=#${c.purple}'
      ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#${c.warning},bold'
      ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#${c.fg2}'
      ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#${c.fg2}'
      ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#${c.purple}'
      ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#${c.success}'
      ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#${c.success}'
      ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#${c.success}'
      ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#${c.purple}'
      ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#${c.purple}'
      ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#${c.purple}'
      ZSH_HIGHLIGHT_STYLES[assign]='fg=#${c.fg2}'
      ZSH_HIGHLIGHT_STYLES[redirection]='fg=#${c.warning}'
      ZSH_HIGHLIGHT_STYLES[comment]='fg=#${c.muted},italic'

      export STALBAR_FZF_THEME_OPTS='--color=fg:#${c.fg1},bg:#${c.bg0},hl:#${c.accent},fg+:#${c.fg0},bg+:#${c.bg2},hl+:#${c.accent3},info:#${c.info},prompt:#${c.accent2},pointer:#${c.purple},marker:#${c.success},spinner:#${c.warning},header:#${c.fg2},border:#${c.bg3}'
      if [[ -z "''${STALBAR_FZF_USER_OPTS_SET:-}" ]]; then
        export STALBAR_FZF_USER_OPTS="''${FZF_DEFAULT_OPTS:-}"
        export STALBAR_FZF_USER_OPTS_SET=1
      fi
      export FZF_DEFAULT_OPTS="$STALBAR_FZF_THEME_OPTS''${STALBAR_FZF_USER_OPTS:+ $STALBAR_FZF_USER_OPTS}"
    '';

  mkWaybarCss =
    theme:
    let
      c = theme.colors;
      barBg = "#${c.bg0}";
      chipBg = "#${c.bg1}";
      chipHover = "#${c.bg2}";
      clockColor = if theme.mode == "light" then "#${c.fg0}" else "#${c.accent}";
    in
    ''
      * {
        font-family: "JetBrainsMono Nerd Font Mono", "JetBrains Mono Nerd Font Mono", monospace;
        font-size: 12px;
        min-height: 0;
        border: none;
        transition: none;
      }

      window#waybar {
        background-color: ${barBg};
        border: 1px solid #${c.bg3};
        border-radius: 16px;
        color: #${c.fg0};
        box-shadow: inset 0 1px #${c.bg2}, 0 10px 30px #${c.bg0}2a;
      }

      window#waybar > box {
        padding: 5px 3px;
      }

      #workspaces,
      #taskbar,
      #custom-theme,
      #pulseaudio,
      #custom-mic,
      #battery,
      #language,
      #tray,
      #clock {
        background: transparent;
        padding: 2px 0;
        margin: 2px 0;
      }

      #workspaces {
        padding: 2px 0;
      }

      #taskbar {
        padding: 2px 0;
      }

      #taskbar button,
      #workspaces button {
        background: ${chipBg};
        background-color: ${chipBg};
        background-image: none;
        border: none;
        box-shadow: none;
        outline: none;
        border-radius: 10px;
        min-width: 22px;
        min-height: 22px;
        padding: 0;
        margin: 1px 0;
      }

      #taskbar button,
      #workspaces button {
        color: #${c.fg0};
      }

      #taskbar button *,
      #workspaces button * {
        background: transparent;
        background-color: transparent;
        background-image: none;
        border: none;
        box-shadow: none;
      }

      #taskbar button:hover,
      #workspaces button:hover,
      #workspaces button.active {
        background-image: none;
        border: none;
        box-shadow: none;
      }

      #taskbar button:hover,
      #workspaces button:hover {
        background: ${chipHover};
        background-color: ${chipHover};
        color: #${c.fg0};
      }

      #workspaces button.active {
        background: #${c.accent2};
        background-color: #${c.accent2};
        color: #${c.bg0};
      }

      #taskbar button.active,
      #taskbar button.focused {
        background: ${chipBg};
        background-color: ${chipBg};
        color: #${c.fg0};
      }

      #taskbar button image,
      #workspaces button label {
        padding: 0;
        margin: 0;
      }

      #taskbar button box,
      #taskbar button label,
      #taskbar button image,
      #workspaces button label {
        background: transparent;
        background-image: none;
      }

      #taskbar button.urgent,
      #workspaces button.urgent {
        color: #${c.fg0};
        background: #${c.error};
        background-color: #${c.error};
      }

      #custom-theme,
      #pulseaudio,
      #custom-mic,
      #battery,
      #language,
      #tray,
      #clock {
        background-color: ${chipBg};
        border-radius: 12px;
        margin: 1px 0;
      }

      #custom-theme {
        font-size: 19px;
        color: #${c.purple};
        padding: 4px 0;
      }

      #pulseaudio {
        font-size: 19px;
        color: #${c.info};
        padding: 4px 0;
      }

      #custom-mic {
        font-size: 19px;
        color: #${c.accent};
        padding: 4px 0;
      }

      #battery {
        font-size: 19px;
        color: #${c.success};
        padding: 4px 0;
      }

      #battery.warning {
        color: #${c.orange};
      }

      #battery.critical:not(.charging) {
        color: #${c.error};
      }

      #language {
        color: #${c.warning};
        font-size: 11px;
        font-weight: 700;
        padding: 5px 0;
      }

      #tray {
        padding: 5px 0;
      }

      #clock.stack {
        color: ${clockColor};
        font-size: 16px;
        font-weight: 800;
        padding: 6px 0;
      }

      tooltip {
        color: #${c.fg0};
        background-color: ${barBg};
        border: 1px solid #${c.accent2};
        border-radius: 8px;
      }
    '';

  mkHyprlandTheme =
    theme:
    let
      c = theme.colors;
    in
    ''
      general {
        col.active_border = rgba(${c.purple}ee) rgba(${c.accent2}cc) 45deg
        col.inactive_border = rgba(${c.bg0}55)
      }
    '';

  mkGhosttyTheme =
    theme:
    let
      c = theme.colors;
      ghosttyOpacity = if theme.mode == "light" then "0.985" else "0.95";
    in
    ''
      foreground = #${c.fg0}
      background = #${c.bg0}
      background-opacity = ${ghosttyOpacity}
      cursor-color = #${c.fg0}
      cursor-text = #${c.bg0}
      selection-background = #${c.accent2}
      selection-foreground = #${c.fg0}
      split-divider-color = #${c.bg3}
      unfocused-split-fill = #${c.bg0}
      window-titlebar-background = #${c.bg0}
      window-titlebar-foreground = #${c.fg0}

      palette = 0=#${c.bg1}
      palette = 8=#${c.bg3}
      palette = 1=#${c.error}
      palette = 9=#${c.error}
      palette = 2=#${c.success}
      palette = 10=#${c.success}
      palette = 3=#${c.warning}
      palette = 11=#${c.warning}
      palette = 4=#${c.accent3}
      palette = 12=#${c.accent2}
      palette = 5=#${c.purple}
      palette = 13=#${c.purple}
      palette = 6=#${c.accent}
      palette = 14=#${c.info}
      palette = 7=#${c.fg2}
      palette = 15=#${c.fg0}
    '';

  mkRofiTheme =
    theme:
    let
      c = theme.colors;
    in
    ''
      * {
        bg: #${c.bg0}F2;
        bg-alt: #${c.bg1};
        fg: #${c.fg0};
        fg-dim: #${c.fg1};
        accent: #${c.accent3};
        selected: #${c.accent2};
        urgent: #${c.error};
        border-col: #${c.bg3};
        border-radius: 10px;
        spacing: 10px;
      }

      window {
        width: 760px;
        height: 560px;
        location: center;
        anchor: center;
        fullscreen: false;
        padding: 16px;
        border: 1px;
        border-color: @border-col;
        border-radius: @border-radius;
        background-color: @bg;
      }

      mainbox {
        spacing: 12px;
        children: [ "inputbar", "listview" ];
        background-color: transparent;
      }

      inputbar {
        padding: 10px 12px;
        spacing: 10px;
        border: 1px;
        border-color: @border-col;
        border-radius: 8px;
        background-color: @bg-alt;
        children: [ "prompt", "entry" ];
      }

      prompt {
        text-color: @accent;
        background-color: transparent;
      }

      entry {
        placeholder: "Search";
        placeholder-color: @fg-dim;
        text-color: @fg;
        background-color: transparent;
      }

      listview {
        lines: 9;
        columns: 1;
        fixed-height: true;
        cycle: true;
        dynamic: false;
        scrollbar: false;
        layout: vertical;
        spacing: 6px;
        background-color: transparent;
      }

      element {
        padding: 10px 12px;
        border: 0;
        border-radius: 8px;
        background-color: transparent;
        text-color: @fg;
      }

      element normal.normal {
        background-color: transparent;
        text-color: @fg;
      }

      element normal.urgent {
        background-color: transparent;
        text-color: @urgent;
      }

      element selected.normal {
        background-color: @selected;
        text-color: #${c.fg0};
      }

      element selected.urgent {
        background-color: @urgent;
        text-color: #${c.fg0};
      }

      element-icon {
        size: 1.2em;
        background-color: transparent;
      }

      element-text {
        vertical-align: 0.5;
        text-color: inherit;
        background-color: transparent;
      }
    '';

  mkBtopTheme =
    theme:
    let
      c = theme.colors;
    in
    ''
      theme[main_bg]="#${c.bg0}"
      theme[main_fg]="#${c.fg1}"
      theme[title]="#${c.accent}"
      theme[hi_fg]="#${c.accent2}"
      theme[selected_bg]="#${c.bg3}"
      theme[selected_fg]="#${c.fg0}"
      theme[inactive_fg]="#${c.muted}"
      theme[proc_misc]="#${c.accent3}"

      theme[cpu_box]="#${c.bg3}"
      theme[mem_box]="#${c.bg3}"
      theme[net_box]="#${c.bg3}"
      theme[proc_box]="#${c.bg3}"
      theme[div_line]="#${c.bg3}"

      theme[temp_start]="#${c.warning}"
      theme[temp_mid]="#${c.warning}"
      theme[temp_end]="#${c.warning}"

      theme[cpu_start]="#${c.accent}"
      theme[cpu_mid]="#${c.accent}"
      theme[cpu_end]="#${c.accent}"

      theme[free_start]="#${c.success}"
      theme[free_mid]="#${c.success}"
      theme[free_end]="#${c.success}"

      theme[cached_start]="#${c.accent3}"
      theme[cached_mid]="#${c.accent3}"
      theme[cached_end]="#${c.accent3}"

      theme[available_start]="#${c.info}"
      theme[available_mid]="#${c.info}"
      theme[available_end]="#${c.info}"

      theme[used_start]="#${c.accent2}"
      theme[used_mid]="#${c.accent2}"
      theme[used_end]="#${c.accent2}"

      theme[download_start]="#${c.accent}"
      theme[download_mid]="#${c.accent}"
      theme[download_end]="#${c.accent}"

      theme[upload_start]="#${c.accent2}"
      theme[upload_mid]="#${c.accent2}"
      theme[upload_end]="#${c.accent2}"
    '';

  mkFirefoxUserChromeTheme =
    theme:
    let
      c = theme.colors;
    in
    ''
      :root {
        --nord0: #${c.bg0};
        --nord1: #${c.bg1};
        --nord2: #${c.bg2};
        --nord3: #${c.bg3};
        --nord4: #${c.fg1};
        --nord6: #${c.fg0};
        --nord8: #${c.accent};
        --nord10: #${c.accent2};
      }
    '';

  mkFirefoxUserContentTheme =
    theme:
    let
      c = theme.colors;
    in
    ''
      :root,
      #root {
        --nord0: #${c.bg0} !important;
        --nord1: #${c.bg1} !important;
        --nord2: #${c.bg2} !important;
        --nord3: #${c.bg3} !important;
        --nord4: #${c.fg1} !important;
        --nord6: #${c.fg0} !important;
        --nord10: #${c.accent2} !important;
        --tab-active-bg: #${c.accent2}38 !important;
      }
    '';

  mkObsidianSnippet =
    theme:
    let
      c = theme.colors;
    in
    ''
      :root {
        --font-interface-theme: "JetBrainsMono Nerd Font Mono";
        --font-text-theme: "JetBrainsMono Nerd Font Mono";
        --font-monospace-theme: "JetBrainsMono Nerd Font Mono";
      }

      .theme-dark,
      .theme-light {
        --background-primary: #${c.bg0};
        --background-primary-alt: #${c.bg0};
        --background-secondary: #${c.bg1};
        --background-secondary-alt: #${c.bg1};
        --background-modifier-border: #${c.fg1};
        --background-modifier-hover: #${c.bg2};
        --background-modifier-form-field: #${c.bg1};
        --background-modifier-form-field-highlighted: #${c.bg2};
        --interactive-accent: #${c.accent};
        --interactive-accent-hover: #${c.info};
        --text-normal: #${c.fg0};
        --text-muted: #${c.fg1};
        --text-faint: #${c.muted};
        --text-accent: #${c.info};
        --text-on-accent: #${c.fg0};
        --titlebar-background: #${c.bg0};
        --titlebar-background-focused: #${c.bg0};
        --divider-color: #${c.fg1};
        --tab-outline-color: #${c.fg1};
        --h1-color: #${c.fg0};
        --h2-color: #${c.fg1};
        --h3-color: #${c.accent3};
        --link-color: #${c.accent};
        --link-external-color: #${c.accent3};
        --code-normal: #${c.fg0};
        --code-background: #${c.bg1}CC;
        --text-selection: #${c.accent}52;
        --nav-item-color: #${c.fg1};
        --nav-item-color-hover: #${c.fg0};
        --nav-item-background-hover: #${c.accent2}38;
        --nav-item-color-active: #${c.fg0};
        --nav-item-background-active: #${c.accent2}59;
        --graph-line: #${c.fg1};
        --graph-node: #${c.accent};
        --graph-node-unresolved: #${c.orange};
        --graph-node-tag: #${c.success};
      }

      * {
        animation: none !important;
        transition: none !important;
      }

      .workspace-ribbon.mod-left {
        display: none;
      }

      .workspace-split.mod-left-split .workspace-leaf-content[data-type="graph"] .view-content {
        min-height: 170px;
        max-height: 220px;
        border-top: 1px solid #${c.fg1}59;
      }

      .workspace-split.mod-left-split .workspace-leaf-content[data-type="graph"] canvas {
        opacity: 1;
      }
    '';

  mkObsidianAppearance =
    theme:
    builtins.toJSON {
      theme = "obsidian";
      cssTheme = "";
      accentColor = "#${theme.colors.accent}";
      baseFontSize = 16;
      interfaceFontFamily = "JetBrainsMono Nerd Font Mono";
      textFontFamily = "JetBrainsMono Nerd Font Mono";
      monospaceFontFamily = "JetBrainsMono Nerd Font Mono";
      enabledCssSnippets = [ "runtime-theme" ];
    };

  mkHyprlockTheme =
    theme:
    let
      c = theme.colors;
    in
    ''
      $lock_surface = rgba(${c.bg0}8c)
      $lock_border = rgba(${c.accent2}73)
      $lock_time = rgba(${c.fg0}f5)
      $lock_date = rgba(${c.fg1}db)
      $lock_input_outer = rgba(${c.accent2}e6)
      $lock_input_inner = rgba(${c.bg1}cc)
      $lock_input_font = rgb(${c.fg1})
      $lock_check = rgb(${c.success})
      $lock_fail = rgb(${c.error})
    '';

  mkQuickshellTheme =
    theme:
    let
      c = theme.colors;
    in
    ''
      pragma Singleton
      import QtQuick

      QtObject {
          readonly property color overlay: "${alphaHex (if theme.mode == "light" then "62" else "76") c.bg0}"
          readonly property color panel: "${alphaHex (if theme.mode == "light" then "D8" else "E8") c.bg0}"
          readonly property color panelRaised: "${alphaHex (if theme.mode == "light" then "E8" else "F4") c.bg1}"
          readonly property color panelBorder: "${alphaHex "B0" c.accent2}"
          readonly property color panelMutedBorder: "${alphaHex "90" c.bg3}"
          readonly property color panelShadow: "${alphaHex "48" c.bg1}"
          readonly property color field: "${alphaHex "BE" c.bg1}"
          readonly property color fieldText: "#${c.fg0}"
          readonly property color fieldMuted: "#${c.fg1}"
          readonly property color fieldBorder: "${alphaHex "90" c.bg3}"
          readonly property color listBg: "${alphaHex "A8" c.bg1}"
          readonly property color listBorder: "${alphaHex "84" c.bg3}"
          readonly property color rowIdle: "${alphaHex "70" c.bg1}"
          readonly property color rowHover: "${alphaHex "96" c.bg2}"
          readonly property color rowActive: "${alphaHex "B2" c.accent2}"
          readonly property color text: "#${c.fg0}"
          readonly property color textMuted: "#${c.fg1}"
          readonly property color actionIdle: "${alphaHex "B8" c.bg2}"
          readonly property color actionHover: "${alphaHex "7A" c.accent2}"
          readonly property color actionBorder: "${alphaHex "8A" c.bg3}"
          readonly property color accentSoft: "${alphaHex "62" c.accent2}"
          readonly property color accentStrong: "#${c.accent2}"
      }
    '';

  themeAssets = pkgs.runCommandLocal "stalbar-theme-assets" { } ''
    ${lib.concatMapStringsSep "\n" (theme: ''
      mkdir -p "$out/${theme.id}"

      cp ${pkgs.writeText "${theme.id}-waybar-theme.css" (mkWaybarCss theme)} "$out/${theme.id}/waybar-theme.css"
      cp ${pkgs.writeText "${theme.id}-hyprland-theme.conf" (mkHyprlandTheme theme)} "$out/${theme.id}/hyprland-theme.conf"
      cp ${pkgs.writeText "${theme.id}-ghostty-theme" (mkGhosttyTheme theme)} "$out/${theme.id}/ghostty-theme"
      cp ${pkgs.writeText "${theme.id}-rofi-theme.rasi" (mkRofiTheme theme)} "$out/${theme.id}/rofi-theme.rasi"
      cp ${pkgs.writeText "${theme.id}-btop.theme" (mkBtopTheme theme)} "$out/${theme.id}/btop.theme"
      cp ${pkgs.writeText "${theme.kdeColorScheme}.colors" (mkKdeColors theme)} "$out/${theme.id}/${theme.kdeColorScheme}.colors"
      cp ${pkgs.writeText "${theme.id}-kdeglobals" (mkKdeGlobals theme)} "$out/${theme.id}/kdeglobals"
      cp ${pkgs.writeText "${theme.id}-gtk-settings.ini" (mkGtkSettings theme)} "$out/${theme.id}/gtk-settings.ini"
      cp ${pkgs.writeText "${theme.id}-gtk.css" (mkGtkCss theme)} "$out/${theme.id}/gtk.css"
      cp ${pkgs.writeText "${theme.id}-qtct.conf" (mkQtctConf theme)} "$out/${theme.id}/qtct.conf"
      cp ${pkgs.writeText "${theme.id}-starship.toml" (mkStarshipConfig theme)} "$out/${theme.id}/starship.toml"
      cp ${pkgs.writeText "${theme.id}-zsh-theme.zsh" (mkZshTheme theme)} "$out/${theme.id}/zsh-theme.zsh"
      cp ${pkgs.writeText "${theme.id}-firefox-userChrome-theme.css" (mkFirefoxUserChromeTheme theme)} "$out/${theme.id}/firefox-userChrome-theme.css"
      cp ${pkgs.writeText "${theme.id}-firefox-userContent-theme.css" (mkFirefoxUserContentTheme theme)} "$out/${theme.id}/firefox-userContent-theme.css"
      cp ${pkgs.writeText "${theme.id}-obsidian-runtime-theme.css" (mkObsidianSnippet theme)} "$out/${theme.id}/obsidian-runtime-theme.css"
      cp ${pkgs.writeText "${theme.id}-obsidian-appearance.json" (mkObsidianAppearance theme)} "$out/${theme.id}/obsidian-appearance.json"
      cp ${pkgs.writeText "${theme.id}-hyprlock-theme.conf" (mkHyprlockTheme theme)} "$out/${theme.id}/hyprlock-theme.conf"
      cp ${pkgs.writeText "QuickshellTheme.qml" (mkQuickshellTheme theme)} "$out/${theme.id}/QuickshellTheme.qml"
      cp ${pkgs.writeText "quickshell-qmldir" ''
        singleton QuickshellTheme 1.0 QuickshellTheme.qml
      ''} "$out/${theme.id}/qmldir"
    '') themeList}
  '';

  switchTheme = pkgs.writeShellApplication {
    name = "switch-theme";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      gnused
      glib
      gsettings-desktop-schemas
      ghostty
      neovim
      procps
      systemd
      waybar
      dunst
    ];
    text = ''
            set -euo pipefail

            assets_dir="${themeAssets}"
            state_dir="${themeStateDir}"
            generated_dir="${generatedThemeDir}"
            current_file="$state_dir/current"
            color_scheme_dir="$HOME/.local/share/color-schemes"
            btop_theme_dir="$HOME/.config/btop/themes"
            firefox_chrome_dir="$HOME/.mozilla/firefox/stalbar/chrome"
            obsidian_dir="$HOME/obsidian-notes/.obsidian"
            nvim_server_dir="$HOME/.local/state/stalbar-theme/nvim-servers"
            gsettings_schema_dir="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas"
            default_theme="${builtins.head themeIds}"
            manage_gui=1
            theme_order=(${lib.concatStringsSep " " themeIds})

            read_current_theme() {
              local theme
              if [ -f "$current_file" ]; then
                theme="$(tr -d '[:space:]' < "$current_file")"
              else
                theme="$default_theme"
              fi

              case "$theme" in
                ${themeNamesText})
                  printf '%s' "$theme"
                  ;;
                *)
                  printf '%s' "$default_theme"
                  ;;
              esac
            }

            next_theme() {
              local current idx count
              current="$(read_current_theme)"
              count="''${#theme_order[@]}"

              for idx in "''${!theme_order[@]}"; do
                if [ "''${theme_order[$idx]}" = "$current" ]; then
                  printf '%s' "''${theme_order[$(((idx + 1) % count))]}"
                  return 0
                fi
              done

              printf '%s' "$default_theme"
            }

            restart_waybar() {
              if systemctl --user --quiet is-enabled waybar.service >/dev/null 2>&1; then
                systemctl --user restart waybar.service >/dev/null 2>&1 || true
              elif [ -n "''${WAYLAND_DISPLAY:-}" ] && pgrep -x waybar >/dev/null 2>&1; then
                pkill -x waybar || true
                nohup waybar >/dev/null 2>&1 &
              fi
            }

            set_theme_vars() {
              case "$1" in
      ${lib.concatMapStringsSep "\n" (theme: ''
        ${theme.id})
          gtk_theme=${lib.escapeShellArg theme.gtkTheme}
          icon_theme=${lib.escapeShellArg theme.iconTheme}
          cursor_theme=${lib.escapeShellArg theme.cursorTheme}
          gtk_color_scheme=${lib.escapeShellArg theme.gtkColorScheme}
        kde_scheme=${lib.escapeShellArg theme.kdeColorScheme}
        hypr_active_border="rgba(${theme.colors.purple}ee) rgba(${theme.colors.accent2}cc) 45deg"
        hypr_inactive_border="rgba(${theme.colors.bg0}55)"
        ;;
      '') themeList}
                *)
                  echo "Unknown theme: $1" >&2
                  exit 2
                  ;;
              esac
            }

            write_runtime_files() {
              local theme="$1"

              mkdir -p "$state_dir" "$generated_dir" "$color_scheme_dir" "$btop_theme_dir" "$HOME/.config"
              mkdir -p "$firefox_chrome_dir" "$obsidian_dir/snippets"
              mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/qt5ct" "$HOME/.config/qt6ct"
              mkdir -p "$HOME/.config/ghostty/themes"
              mkdir -p "$HOME/.config/environment.d"

              printf '%s\n' "$theme" > "$current_file"

              install -m 0644 "$assets_dir/$theme/ghostty-theme" "$generated_dir/ghostty-theme"
              install -m 0644 "$assets_dir/$theme/ghostty-theme" "$HOME/.config/ghostty/themes/stalbar-runtime"
              install -m 0644 "$assets_dir/$theme/rofi-theme.rasi" "$generated_dir/rofi-theme.rasi"
              install -m 0644 "$assets_dir/$theme/waybar-theme.css" "$generated_dir/waybar-theme.css"
              install -m 0644 "$assets_dir/$theme/hyprlock-theme.conf" "$generated_dir/hyprlock-theme.conf"
              install -m 0644 "$assets_dir/$theme/QuickshellTheme.qml" "$generated_dir/QuickshellTheme.qml"
              install -m 0644 "$assets_dir/$theme/qmldir" "$generated_dir/qmldir"
              install -m 0644 "$assets_dir/$theme/starship.toml" "$generated_dir/starship.toml"
              install -m 0644 "$assets_dir/$theme/starship.toml" "$HOME/.config/starship.toml"
              install -m 0644 "$assets_dir/$theme/zsh-theme.zsh" "$generated_dir/zsh-theme.zsh"
              install -m 0644 "$assets_dir/$theme/btop.theme" "$btop_theme_dir/current.theme"
              install -m 0644 "$assets_dir/$theme/$kde_scheme.colors" "$color_scheme_dir/$kde_scheme.colors"
              install -m 0644 "$assets_dir/$theme/kdeglobals" "$HOME/.config/kdeglobals"
              install -m 0644 "$assets_dir/$theme/gtk-settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
              install -m 0644 "$assets_dir/$theme/gtk-settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
              install -m 0644 "$assets_dir/$theme/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
              install -m 0644 "$assets_dir/$theme/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
              install -m 0644 "$assets_dir/$theme/qtct.conf" "$HOME/.config/qt5ct/qt5ct.conf"
              install -m 0644 "$assets_dir/$theme/qtct.conf" "$HOME/.config/qt6ct/qt6ct.conf"
              install -m 0644 "$assets_dir/$theme/firefox-userChrome-theme.css" "$firefox_chrome_dir/stalbar-theme-userChrome.css"
              install -m 0644 "$assets_dir/$theme/firefox-userContent-theme.css" "$firefox_chrome_dir/stalbar-theme-userContent.css"
              install -m 0644 "$assets_dir/$theme/obsidian-runtime-theme.css" "$obsidian_dir/snippets/runtime-theme.css"
              install -m 0644 "$assets_dir/$theme/obsidian-appearance.json" "$obsidian_dir/appearance.json"
              cat > "$HOME/.config/environment.d/90-stalbar-theme.conf" <<EOF
XCURSOR_THEME=$cursor_theme
XCURSOR_SIZE=24
GTK_THEME=$gtk_theme
EOF
            }

            apply_theme() {
              local theme="$1"
              local okular_rc

              set_theme_vars "$theme"
              write_runtime_files "$theme"

              if command -v gsettings >/dev/null 2>&1 && [ -d "$gsettings_schema_dir" ]; then
                GSETTINGS_SCHEMA_DIR="$gsettings_schema_dir" gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" >/dev/null 2>&1 || true
                GSETTINGS_SCHEMA_DIR="$gsettings_schema_dir" gsettings set org.gnome.desktop.interface icon-theme "$icon_theme" >/dev/null 2>&1 || true
                GSETTINGS_SCHEMA_DIR="$gsettings_schema_dir" gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme" >/dev/null 2>&1 || true
                GSETTINGS_SCHEMA_DIR="$gsettings_schema_dir" gsettings set org.gnome.desktop.interface color-scheme "$gtk_color_scheme" >/dev/null 2>&1 || true
              fi

              okular_rc="$HOME/.config/okularrc"
              if [ -f "$okular_rc" ]; then
                if grep -q '^ColorScheme=' "$okular_rc"; then
                  sed -i "s/^ColorScheme=.*/ColorScheme=$kde_scheme/" "$okular_rc"
                else
                  printf '\n[UiSettings]\nColorScheme=%s\n' "$kde_scheme" >> "$okular_rc"
                fi
              else
                printf '[UiSettings]\nColorScheme=%s\n' "$kde_scheme" > "$okular_rc"
              fi

              if [ "$manage_gui" -eq 1 ] && command -v hyprctl >/dev/null 2>&1; then
                hyprctl keyword general:col.active_border "$hypr_active_border" >/dev/null 2>&1 || true
                hyprctl keyword general:col.inactive_border "$hypr_inactive_border" >/dev/null 2>&1 || true
                hyprctl setcursor "$cursor_theme" 24 >/dev/null 2>&1 || true
              fi

              if [ "$manage_gui" -eq 1 ]; then
                restart_waybar
              fi

              if [ "$manage_gui" -eq 1 ]; then
                systemctl --user --quiet is-active qs-app-launcher.service >/dev/null 2>&1 && systemctl --user restart qs-app-launcher.service >/dev/null 2>&1 || true
              fi

              if [ -d "$nvim_server_dir" ]; then
                for entry in "$nvim_server_dir"/*; do
                  [ -f "$entry" ] || continue
                  server="$(tr -d '\n' < "$entry")"
                  if [ -z "$server" ]; then
                    rm -f "$entry"
                    continue
                  fi
                  if [ ! -S "$server" ]; then
                    rm -f "$entry"
                    continue
                  fi
                  nvim --server "$server" --remote-expr 'execute("lua require([[config.theme]]).apply()")' >/dev/null 2>&1 || true
                done
              fi

              if [ "$manage_gui" -eq 1 ] && command -v systemctl >/dev/null 2>&1; then
                systemctl reload --user app-com.mitchellh.ghostty.service >/dev/null 2>&1 || true
              fi

              if [ "$manage_gui" -eq 1 ] && [ -n "''${WAYLAND_DISPLAY:-}" ] && pgrep -x dunst >/dev/null 2>&1; then
                pkill -x dunst || true
                nohup dunst >/dev/null 2>&1 &
              fi
            }

            print_waybar_json() {
              local theme
              theme="$(read_current_theme)"

              case "$theme" in
      ${lib.concatMapStringsSep "\n" (theme: ''
        ${theme.id})
          printf '{"text":"","tooltip":"Theme: ${theme.displayName}","class":"${theme.id}"}\n'
          ;;
      '') themeList}
                *)
                  printf '{"text":"","tooltip":"Theme: %s","class":"unknown"}\n' "$theme"
                  ;;
              esac
            }

            case "''${1:---toggle}" in
              --toggle)
                apply_theme "$(next_theme)"
                ;;
              --apply-current)
                apply_theme "$(read_current_theme)"
                ;;
              --apply-current-no-gui)
                manage_gui=0
                apply_theme "$(read_current_theme)"
                ;;
              --set)
                if [ "''${2:-}" = "" ]; then
                  echo "Usage: switch-theme --set <${themeNamesText}>" >&2
                  exit 2
                fi
                apply_theme "$2"
                ;;
              --current)
                read_current_theme
                ;;
              --waybar-json)
                print_waybar_json
                ;;
              *)
                echo "Usage: switch-theme [--toggle|--apply-current|--apply-current-no-gui|--set <${themeNamesText}>|--current|--waybar-json]" >&2
                exit 2
                ;;
            esac
    '';
  };
in
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
    # The runtime theme switcher owns ~/.config/gtk-{3,4}.0 files so themes can
    # change without a Home Manager generation conflict.
    enable = false;

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

    gtk4.theme = config.gtk.theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = [
    pkgs.adw-gtk3
    pkgs.adwaita-qt
    pkgs.bibata-cursors
    pkgs.dracula-icon-theme
    pkgs.gnome-themes-extra
    pkgs.gruvbox-gtk-theme
    pkgs.gruvbox-plus-icons
    pkgs.hicolor-icon-theme
    pkgs.kanagawa-icon-theme
    pkgs.libsForQt5.qt5ct
    pkgs.nordic
    pkgs.papirus-icon-theme
    pkgs.qt6Packages.qt6ct
    pkgs.rose-pine-cursor
    pkgs.rose-pine-icon-theme
    switchTheme
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    XCURSOR_SIZE = "24";
  };

  home.activation.themeRuntimeBootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${themeStateDir}"
    if [ ! -f "${themeStateDir}/current" ]; then
      printf '%s\n' ${builtins.head themeIds} > "${themeStateDir}/current"
    fi

    ${switchTheme}/bin/switch-theme --apply-current-no-gui >/dev/null 2>&1 || true
  '';
}
