{ pkgs, ... }:

let
  colors = import ../theme/colors.nix;

  tokyoNightCss = ''
    /* Tokyo Night Neon styling for Zen / Firefox Browser */
    :root {
      --zen-colors-bg: ${colors.bg} !important;
      --zen-colors-fg: ${colors.fg} !important;
      --zen-colors-tertiary: #24283b !important;
      --zen-colors-accent: ${colors.cyan} !important;
      --zen-colors-border: #1f2335 !important;
      --lwt-accent-color: ${colors.bg} !important;
      --lwt-text-color: ${colors.fg} !important;
      --toolbar-background: ${colors.bg} !important;
      --tab-selected-bg: #24283b !important;
    }

    #main-window, body, #navigator-toolbox {
      background-color: ${colors.bg} !important;
      color: ${colors.fg} !important;
    }

    .tabbrowser-tab[selected="true"] {
      background-color: #24283b !important;
      color: ${colors.cyan} !important;
      border-radius: 8px !important;
    }
  '';
in
{
  # TokyoNight styling & extensions for Zen/Firefox browser
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        # uBlock Origin (General & YouTube Adblocker)
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      Preferences = {
        "browser.tabs.vertical" = true;
        "zen.tabs.vertical" = true;
        "browser.theme.content-theme" = 0; # Dark
        "browser.theme.toolbar-theme" = 0; # Dark
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };

  # Deploy userChrome.css for Zen browser
  home.file.".zen/userChrome.css".text = tokyoNightCss;
}
