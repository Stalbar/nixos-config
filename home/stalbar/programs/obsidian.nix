{
  config,
  lib,
  pkgs,
  ...
}:

let
  vaultPath = "${config.home.homeDirectory}/obsidian-notes";
  oldVaultPath = "${config.home.homeDirectory}/Notes";
  obsidianStatePath = "${config.home.homeDirectory}/.config/obsidian";

  corePlugins = [
    "file-explorer"
    "search"
    "quick-switcher"
    "graph"
    "backlink"
    "outgoing-link"
    "tag-pane"
    "outline"
    "command-palette"
    "workspaces"
    "templates"
    "daily-notes"
    "slash-command"
  ];

  communityPlugins = [
    "calendar"
    "dataview"
    "obsidian-tasks-plugin"
    "templater-obsidian"
    "quickadd"
    "obsidian-linter"
  ];

  globalConfigJson = builtins.toJSON {
    vaults = {
      notes = {
        path = vaultPath;
        ts = 0;
        open = true;
      };
    };
  };

  appConfigJson = builtins.toJSON {
    legacyEditor = false;
    livePreview = true;
    showInlineTitle = true;
    alwaysUpdateLinks = true;
    promptDelete = false;
    showLineNumber = false;
    showFrontmatter = false;
    showViewHeader = false;
    newFileLocation = "folder";
    newFileFolderPath = "00 Inbox";
    attachmentFolderPath = "90 Archive/attachments";
    useMarkdownLinks = true;
    strictLineBreaks = false;
    readableLineLength = false;
    showRibbon = false;
    spellcheck = true;
    defaultViewMode = "source";
  };

  appearanceConfigJson = builtins.toJSON {
    theme = "obsidian";
    cssTheme = "";
    accentColor = "#88C0D0";
    baseFontSize = 16;
    interfaceFontFamily = "JetBrainsMono Nerd Font Mono";
    textFontFamily = "JetBrainsMono Nerd Font Mono";
    monospaceFontFamily = "JetBrainsMono Nerd Font Mono";
    enabledCssSnippets = [ "runtime-theme" ];
  };

  workspaceConfigJson = builtins.toJSON {
    main = {
      id = "main-root";
      type = "split";
      direction = "vertical";
      children = [
        {
          id = "main-tabs";
          type = "tabs";
          children = [
            {
              id = "main-leaf";
              type = "leaf";
              state = {
                type = "empty";
                state = { };
              };
            }
          ];
        }
      ];
    };

    left = {
      id = "left-root";
      type = "split";
      direction = "vertical";
      sizes = [
        0.74
        0.26
      ];
      children = [
        {
          id = "left-files";
          type = "tabs";
          children = [
            {
              id = "file-explorer-leaf";
              type = "leaf";
              state = {
                type = "file-explorer";
                state = { };
              };
            }
          ];
        }
        {
          id = "left-graph";
          type = "tabs";
          children = [
            {
              id = "graph-leaf";
              type = "leaf";
              state = {
                type = "graph";
                state = {
                  type = "local";
                  file = null;
                };
              };
            }
          ];
        }
      ];
    };

    right = {
      id = "right-root";
      type = "split";
      direction = "vertical";
      children = [ ];
    };

    active = "main-leaf";
    lastOpenFiles = [ ];
  };

  obsidianPluginSync = pkgs.writeShellApplication {
    name = "obsidian-plugin-sync";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      jq
      gnused
    ];
    text = ''
      set -euo pipefail

      vault_dir="''${1:-$HOME/obsidian-notes}"
      plugins_dir="$vault_dir/.obsidian/plugins"
      mkdir -p "$plugins_dir"

      install_plugin() {
        local id="$1"
        local repo="$2"
        local release_json manifest_url main_url styles_url

        release_json="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest")"
        manifest_url="$(printf '%s' "$release_json" | jq -r '.assets[] | select(.name == "manifest.json") | .browser_download_url' | head -n1)"
        main_url="$(printf '%s' "$release_json" | jq -r '.assets[] | select(.name == "main.js") | .browser_download_url' | head -n1)"
        styles_url="$(printf '%s' "$release_json" | jq -r '.assets[] | select(.name == "styles.css" or .name == "style.css") | .browser_download_url' | head -n1)"

        if [ -z "$manifest_url" ] || [ -z "$main_url" ]; then
          echo "Skipping $id: missing release assets in $repo" >&2
          return 1
        fi

        mkdir -p "$plugins_dir/$id"
        curl -fsSL "$manifest_url" -o "$plugins_dir/$id/manifest.json"
        curl -fsSL "$main_url" -o "$plugins_dir/$id/main.js"
        if [ -n "$styles_url" ]; then
          curl -fsSL "$styles_url" -o "$plugins_dir/$id/styles.css"
        fi

        echo "Installed $id"
      }

      failed=0
      install_plugin "calendar" "liamcain/obsidian-calendar-plugin" || failed=1
      install_plugin "dataview" "blacksmithgu/obsidian-dataview" || failed=1
      install_plugin "obsidian-tasks-plugin" "obsidian-tasks-group/obsidian-tasks" || failed=1
      install_plugin "templater-obsidian" "SilentVoid13/Templater" || failed=1
      install_plugin "quickadd" "chhoumann/quickadd" || failed=1
      install_plugin "obsidian-linter" "platers/obsidian-linter" || failed=1

      if [ "$failed" -ne 0 ]; then
        echo "Some plugins failed to install. Re-run obsidian-plugin-sync." >&2
        exit 1
      fi
    '';
  };
in
{
  home.packages = [
    obsidianPluginSync
  ];

  home.activation.obsidianBootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        vault_dir="${vaultPath}"
        obsidian_dir="$vault_dir/.obsidian"
        state_dir="${obsidianStatePath}"

        mkdir -p \
          "$vault_dir/00 Inbox" \
          "$vault_dir/01 Projects" \
          "$vault_dir/02 Areas" \
          "$vault_dir/90 Archive" \
          "$obsidian_dir/snippets" \
          "$obsidian_dir/plugins" \
          "$state_dir"

        if [ ! -f "$state_dir/obsidian.json" ]; then
          cat > "$state_dir/obsidian.json" <<'EOF'
    ${globalConfigJson}
    EOF
        elif grep -Fq "${oldVaultPath}" "$state_dir/obsidian.json"; then
          sed -i "s|${oldVaultPath}|${vaultPath}|g" "$state_dir/obsidian.json"
        fi

        if [ ! -f "$obsidian_dir/app.json" ]; then
          cat > "$obsidian_dir/app.json" <<'EOF'
    ${appConfigJson}
    EOF
        fi

        if [ ! -f "$obsidian_dir/appearance.json" ]; then
          cat > "$obsidian_dir/appearance.json" <<'EOF'
    ${appearanceConfigJson}
    EOF
        fi

        if [ ! -f "$obsidian_dir/snippets/runtime-theme.css" ]; then
          : > "$obsidian_dir/snippets/runtime-theme.css"
        fi

        if [ ! -f "$obsidian_dir/core-plugins.json" ]; then
          cat > "$obsidian_dir/core-plugins.json" <<'EOF'
    ${builtins.toJSON corePlugins}
    EOF
        fi

        if [ ! -f "$obsidian_dir/community-plugins.json" ]; then
          cat > "$obsidian_dir/community-plugins.json" <<'EOF'
    ${builtins.toJSON communityPlugins}
    EOF
        fi

        if [ ! -f "$obsidian_dir/workspace.json" ]; then
          cat > "$obsidian_dir/workspace.json" <<'EOF'
    ${workspaceConfigJson}
    EOF
        fi

        if [ ! -f "$vault_dir/Home.md" ]; then
          cat > "$vault_dir/Home.md" <<'EOF'
    # Dashboard

    ## Notes
    - [[00 Inbox]]
    - [[01 Projects]]
    - [[02 Areas]]
    - [[90 Archive]]

    ## Quick Links
    - [YouTube](https://youtube.com)
    - [Monkeytype](https://monkeytype.com)
    - [Google](https://google.com)
    - [GitHub](https://github.com)
    - [NixOS Wiki](https://wiki.nixos.org)
    - [Playerok](https://playerok.com)
    EOF
        fi

  '';
}
