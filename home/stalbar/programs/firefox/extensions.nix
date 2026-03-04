{ pkgs, ... }:

let
  ublockXpi = pkgs.fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4675310/ublock_origin-1.69.0.xpi";
    hash = "sha256-eFvN5ool+qiglJlk7F/+m9y4XT8K4hwj9gfGyPkUcs8=";
  };
  sponsorBlockXpi = pkgs.fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4644570/sponsorblock-6.1.2.xpi";
    hash = "sha256-WY9myetrurK9X4c3a2MqWGD0QtNpTiM2EPWzf4tuPxA=";
  };
  sideberyXpi = pkgs.fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4688454/sidebery-5.5.0.xpi";
    hash = "sha256-jVetNRd0QvaonD0xn6PgWGN2ofK3Lw/TAyOG5fNQXbg=";
  };
  darkReaderXpi = pkgs.fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4690921/darkreader-4.9.121.xpi";
    hash = "sha256-wOxdUE6XHfvq3cRvh5x0Cl9MfAN6Z47NMZr7eYb+Y+s=";
  };
in
{
  home.file = {
    ".mozilla/firefox/stalbar/extensions/uBlock0@raymondhill.net.xpi".source = ublockXpi;
    ".mozilla/firefox/stalbar/extensions/sponsorBlocker@ajay.app.xpi".source = sponsorBlockXpi;
    ".mozilla/firefox/stalbar/extensions/{3c078156-979c-498b-8990-85f7987dd929}.xpi".source = sideberyXpi;
    ".mozilla/firefox/stalbar/extensions/addon@darkreader.org.xpi".source = darkReaderXpi;
  };

  programs.firefox = {
    enable = true;

    policies = {
      AppAutoUpdate = false;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      PromptForDownloadLocation = false;
      TranslateEnabled = false;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      ExtensionSettings = {
        "*" = {
          installation_mode = "allowed";
        };

        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };

        "sponsorBlocker@ajay.app" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        };

        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
        };

        "addon@darkreader.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };

      };
    };
  };
}
