{ pkgs, lib, ... }:

let
  sqlEscape = value: lib.replaceStrings [ "'" ] [ "''" ] value;

  falloutSettings = builtins.toJSON {
    fps = 24;
    x = 0;
    y = 0;
    width = 923;
    height = 1056;
    windowScaling = 1;
    showTerminalSize = false;
    fontScaling = 0.86;
    fontNames = [ "TERMINUS_SCALED" "COMMODORE_PET" "COMMODORE_PET" ];
    showMenubar = false;
    bloomQuality = 0.28;
    burnInQuality = 0.65;
    useCustomCommand = false;
    customCommand = "";
  };

  falloutProfile = builtins.toJSON {
    backgroundColor = "#000300";
    fontColor = "#92ff6b";
    flickering = 0.02;
    horizontalSync = 0.0;
    staticNoise = 0.08;
    chromaColor = 0.0;
    saturationColor = 0.0;
    screenCurvature = 0.0;
    glowingLine = 0.08;
    burnIn = 0.18;
    bloom = 0.14;
    rasterization = 0.48;
    jitter = 0.03;
    rbgShift = 0;
    brightness = 0.64;
    contrast = 1.0;
    ambientLight = 0.0;
    windowOpacity = 1;
    fontName = "TERMINUS_SCALED";
    fontWidth = 1;
    margin = 0.04;
    blinkingCursor = false;
    frameMargin = 0.02;
  };

  coolRetroTermFallout = pkgs.writeShellApplication {
    name = "cool-retro-term-fallout";
    runtimeInputs = [ pkgs.cool-retro-term pkgs.sqlite ];
    text = ''
      db="$HOME/.local/share/cool-retro-term/cool-retro-term/QML/OfflineStorage/Databases/27e743fe85b8912a46804fed99e8a9ab.sqlite"
      mkdir -p "$(dirname "$db")"

      sqlite3 "$db" <<'SQL'
      CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT);
      INSERT INTO settings(setting, value)
      VALUES
        ('_CURRENT_SETTINGS', '${sqlEscape falloutSettings}'),
        ('_CURRENT_PROFILE', '${sqlEscape falloutProfile}')
      ON CONFLICT(setting) DO UPDATE SET value = excluded.value;
      SQL

      unset QML2_IMPORT_PATH
      unset QT_PLUGIN_PATH
      unset NIXPKGS_QT5_QML_IMPORT_PATH
      unset NIXPKGS_QT6_QML_IMPORT_PATH
      export QT_STYLE_OVERRIDE=Fusion

      exec cool-retro-term -T "ROBCO INDUSTRIES UOS" "$@"
    '';
  };
in
{
  home.packages = [ coolRetroTermFallout ];

  xdg.desktopEntries.cool-retro-term = {
    name = "Cool Retro Term";
    genericName = "Terminal emulator";
    comment = "Green phosphor CRT terminal";
    exec = "${coolRetroTermFallout}/bin/cool-retro-term-fallout";
    icon = "cool-retro-term";
    terminal = false;
    startupNotify = true;
    categories = [ "System" "TerminalEmulator" ];
    settings = {
      Keywords = "shell;prompt;command;commandline;";
    };
  };
}
