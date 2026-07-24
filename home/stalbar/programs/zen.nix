{ pkgs, ... }:

let
  colors = import ../theme/colors.nix;
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
}
