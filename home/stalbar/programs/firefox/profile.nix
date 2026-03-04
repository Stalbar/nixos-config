{ nord, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.stalbar = {
      id = 0;
      name = "stalbar";
      isDefault = true;

      settings = {
        # Custom CSS support.
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # FF Ultima-like compact UI, Sidebery-first layout.
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "browser.tabs.inTitlebar" = 0;
        "browser.toolbars.bookmarks.visibility" = "never";
        "sidebar.revamp" = false;
        "sidebar.verticalTabs" = false;
        "ui.systemUsesDarkTheme" = 1;
        "layout.css.prefers-color-scheme.content-override" = 2;

        # Minimal motion.
        "ui.prefersReducedMotion" = 1;
        "toolkit.cosmeticAnimations.enabled" = false;
        "browser.tabs.animate" = false;
        "browser.fullscreen.animate" = false;
        "browser.download.animateNotifications" = false;
        "browser.bookmarks.editDialog.delayedApply.enabled" = false;
        "image.animation_mode" = "none";

        # Smooth scrolling (kept, but conservative).
        "general.autoScroll" = true;
        "general.smoothScroll" = true;
        "general.smoothScroll.pages" = true;
        "general.smoothScroll.pixels" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.mouseWheel.durationMinMS" = 90;
        "general.smoothScroll.mouseWheel.durationMaxMS" = 190;
        "apz.gtk.kinetic_scroll.enabled" = true;
        "mousewheel.min_line_scroll_amount" = 24;

        # Performance-oriented defaults.
        "browser.tabs.unloadOnLowMemory" = true;
        "browser.sessionstore.interval" = 900000;
        "browser.startup.page" = 3;
        "browser.startup.homepage" = "about:home";
        "browser.cache.disk.enable" = true;
        "media.hardware-video-decoding.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        "layers.gpu-process.enabled" = true;
        "widget.gtk.overlay-scrollbars.enabled" = true;

        # Privacy/security hardening (balanced, low breakage).
        "browser.formfill.enable" = false;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.quicksuggest.sponsored" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "beacon.enabled" = false;
        "network.prefetch-next" = false;
        "network.dns.disablePrefetch" = true;
        "network.predictor.enabled" = false;
        "security.https_only_mode" = true;
        "dom.security.https_first" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "network.cookie.cookieBehavior" = 1;
        "network.cookie.cookieBehavior.pbmode" = 5;
        "media.autoplay.default" = 1;

        # Keep new tab enabled and lightweight.
        "browser.newtabpage.enabled" = true;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
      };

      userChrome = ''
        :root {
          --nord0: #${nord.nord0};
          --nord1: #${nord.nord1};
          --nord2: #${nord.nord2};
          --nord3: #${nord.nord3};
          --nord4: #${nord.nord4};
          --nord6: #${nord.nord6};
          --nord8: #${nord.nord8};
          --nord10: #${nord.nord10};
          --ffu-sidebar-collapsed: 52px;
          --ffu-sidebar-expanded: 312px;
          --ffu-sidebar-radius: 12px;
          --ffu-toolbar-height: 36px;
        }

        * {
          box-shadow: none !important;
        }

        /* Remove top horizontal tabs completely (Sidebery-only workflow). */
        #TabsToolbar,
        #tabbrowser-tabs,
        #TabsToolbar-customization-target {
          visibility: collapse !important;
          min-height: 0 !important;
          max-height: 0 !important;
        }

        #titlebar {
          appearance: none !important;
        }

        #titlebar-buttonbox-container {
          margin-inline-end: 6px !important;
        }

        #navigator-toolbox,
        #nav-bar,
        #PersonalToolbar {
          background: var(--nord0) !important;
          border: none !important;
        }

        #navigator-toolbox {
          border-bottom: 1px solid color-mix(in srgb, var(--nord3) 55%, transparent) !important;
        }

        #PersonalToolbar {
          display: none !important;
        }

        #nav-bar {
          min-height: var(--ffu-toolbar-height) !important;
          padding-inline: 6px !important;
          -moz-window-dragging: drag !important;
        }

        #nav-bar toolbarbutton,
        #urlbar-container,
        #search-container {
          -moz-window-dragging: no-drag !important;
        }

        #urlbar-background,
        #searchbar {
          background: var(--nord1) !important;
          border: 1px solid color-mix(in srgb, var(--nord3) 70%, transparent) !important;
          border-radius: 10px !important;
        }

        #urlbar[open] > #urlbar-background {
          border-color: var(--nord10) !important;
        }

        #nav-bar toolbarbutton {
          border-radius: 10px !important;
          color: var(--nord4) !important;
          margin: 2px !important;
        }

        #nav-bar toolbarbutton:hover {
          background: color-mix(in srgb, var(--nord2) 80%, transparent) !important;
        }

        #urlbar-input-container {
          color: var(--nord4) !important;
        }

        /* Sidebery frame in sidebar: minimal nord container. */
        #sidebar-box {
          background: var(--nord0) !important;
          border-right: none !important;
          padding: 6px 0 6px 6px !important;
        }

        #sidebar-header {
          display: none !important;
        }

        #sidebar,
        #sidebar-splitter {
          border: none !important;
          background: var(--nord0) !important;
          color: var(--nord4) !important;
        }

        #sidebar-splitter {
          width: 0 !important;
        }

        /* FF Ultima-like icon rail that expands on hover for Sidebery. */
        #sidebar-box[sidebarcommand*="3c078156"] {
          margin: 0 0 0 2px !important;
          min-width: var(--ffu-sidebar-collapsed) !important;
          width: var(--ffu-sidebar-collapsed) !important;
          max-width: var(--ffu-sidebar-collapsed) !important;
          border-right: none !important;
          overflow: hidden !important;
          transition:
            width 95ms ease-out,
            min-width 95ms ease-out,
            max-width 95ms ease-out !important;
        }

        #sidebar-box[sidebarcommand*="3c078156"]:hover {
          min-width: var(--ffu-sidebar-expanded) !important;
          width: var(--ffu-sidebar-expanded) !important;
          max-width: var(--ffu-sidebar-expanded) !important;
        }

        #sidebar-box[sidebarcommand*="3c078156"] + #sidebar-splitter {
          width: 0 !important;
          border: none !important;
        }

        #sidebar-box[sidebarcommand*="3c078156"] #sidebar {
          background: var(--nord1) !important;
          border: 1px solid color-mix(in srgb, var(--nord3) 75%, transparent) !important;
          border-radius: var(--ffu-sidebar-radius) !important;
          overflow: hidden !important;
        }

        #sidebar-box[sidebarcommand*="3c078156"]:not(:hover) #sidebar {
          border-color: transparent !important;
          background: transparent !important;
        }
      '';

      userContent = ''
        /* Sidebery: FF Ultima-like Nord vertical tabs. */
        @-moz-document regexp("^moz-extension://.*/sidebery/.*\\.html$") {
          :root,
          #root {
            --s-frame-bg: #${nord.nord0} !important;
            --s-frame-fg: #${nord.nord4} !important;
            --s-toolbar-bg: #${nord.nord1} !important;
            --s-toolbar-fg: #${nord.nord4} !important;
            --s-toolbar-border: #${nord.nord3} !important;
            --s-popup-bg: #${nord.nord1} !important;
            --s-popup-fg: #${nord.nord6} !important;
            --s-popup-border: #${nord.nord3} !important;
            --s-act-el-bg: #${nord.nord2} !important;
            --s-act-el-fg: #${nord.nord6} !important;
            --s-act-el-border: #${nord.nord10} !important;
            --s-accent: #${nord.nord10} !important;
            --general-font-family: "JetBrainsMono Nerd Font Mono", "JetBrains Mono", monospace !important;
            --general-border-radius: 10px !important;
            --general-margin: 3px !important;
            --tabs-height: 38px !important;
            --tabs-pinned-height: 38px !important;
            --tabs-indent: 10px !important;
            --bookmarks-indent: 10px !important;
            --d-swift: 90ms !important;
            --d-fast: 90ms !important;
            --d-norm: 110ms !important;
            --d-slow: 130ms !important;
            background: #${nord.nord1} !important;
          }

          * {
            box-shadow: none !important;
            text-shadow: none !important;
          }

          .NavigationBar,
          .TopBar,
          .BottomBar {
            background: transparent !important;
            border: none !important;
          }

          .NavigationBar .nav-item,
          .NavigationBar .item {
            border-radius: 10px !important;
            margin: 3px 6px !important;
            border: 1px solid transparent !important;
          }

          .NavigationBar .nav-item:hover,
          .NavigationBar .item:hover {
            background: #${nord.nord2} !important;
            border-color: #${nord.nord3} !important;
          }

          .Tab,
          .PinnedTab {
            position: relative !important;
            margin: 2px 6px !important;
            border-radius: 10px !important;
          }

          .Tab .body,
          .PinnedTab .body,
          .Tab .main,
          .Tab .t-box {
            min-height: 36px !important;
            border-radius: 10px !important;
            border: 1px solid #${nord.nord3} !important;
            background: #${nord.nord1} !important;
          }

          .Tab:hover .body,
          .PinnedTab:hover .body,
          .Tab:hover .main,
          .Tab:hover .t-box {
            background: #${nord.nord2} !important;
            border-color: #${nord.nord10} !important;
          }

          .Tab[data-active="true"] .body,
          .Tab[data-active="true"] .main,
          .Tab[data-active="true"] .t-box,
          .Tab[data-selected="true"] .body,
          .Tab[data-selected="true"] .main,
          .Tab[data-selected="true"] .t-box,
          .Tab.active .body {
            background: rgba(94, 129, 172, 0.22) !important;
            border-color: #${nord.nord10} !important;
          }

          .Tab[data-active="true"]::before,
          .Tab[data-selected="true"]::before,
          .Tab.active::before {
            content: "" !important;
            position: absolute !important;
            left: 4px !important;
            top: 7px !important;
            bottom: 7px !important;
            width: 3px !important;
            border-radius: 6px !important;
            background: #${nord.nord10} !important;
          }

          .Tab .title,
          .PinnedTab .title {
            font-size: 13px !important;
            font-weight: 520 !important;
          }

          .Tab .close,
          .Tab .audio {
            opacity: 0.65 !important;
            transition: opacity 90ms linear !important;
          }

          .Tab:hover .close,
          .Tab:hover .audio {
            opacity: 1 !important;
          }

          .PinnedTabsBar .Tab .title,
          .PinnedTab .title {
            display: none !important;
          }

          /* Collapsed mode: icon rail only. */
          @media (max-width: 100px) {
            .Tab .title,
            .Tab .ctx,
            .Tab .badge,
            .Tab .counter,
            .Tab .audio,
            .Tab .close,
            .PinnedTab .title,
            .PinnedTab .ctx,
            .PinnedTab .badge,
            .PinnedTab .counter,
            .PinnedTab .audio,
            .PinnedTab .close {
              display: none !important;
            }

            .Tab .body,
            .PinnedTab .body,
            .Tab .main,
            .Tab .t-box {
              justify-content: center !important;
              padding-left: 0 !important;
              padding-right: 0 !important;
            }

            .NavigationBar {
              padding-inline: 4px !important;
            }
          }
        }
      '';
    };
  };
}
