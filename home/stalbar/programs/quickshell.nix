{
  config,
  lib,
  pkgs,
  ...
}:

let
  qmlImportPath = lib.concatStringsSep ":" [
    "${pkgs.qt6.qtdeclarative}${pkgs.qt6.qtbase.qtQmlPrefix}"
    "${pkgs.qt6.qt5compat}${pkgs.qt6.qtbase.qtQmlPrefix}"
    "${pkgs.qt6.qtsvg}${pkgs.qt6.qtbase.qtQmlPrefix}"
    "${pkgs.qt6.qtwayland}${pkgs.qt6.qtbase.qtQmlPrefix}"
  ];

  mkQsRunner =
    name: relPath:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [ pkgs.quickshell ];
      text = ''
        set -euo pipefail

        cfg="$HOME/.config/quickshell/${relPath}"
        if [ ! -f "$cfg" ]; then
          echo "Quickshell config not found: $cfg" >&2
          echo "Copy/create your widget config under ~/.config/quickshell first." >&2
          exit 1
        fi

        export QML2_IMPORT_PATH="${qmlImportPath}:''${QML2_IMPORT_PATH:-}"
        export QT_LOGGING_RULES="qt.qpa.theme.gnome.warning=false;''${QT_LOGGING_RULES:-}"
        export QT_QUICK_CONTROLS_STYLE="Basic"
        exec quickshell --path "$cfg"
      '';
    };

  qsAppLauncher = pkgs.writeShellApplication {
    name = "qs-app-launcher";
    runtimeInputs = [
      pkgs.quickshell
      pkgs.systemd
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail

      cfg="$HOME/.config/quickshell/app-launcher/shell.qml"
      if [ ! -f "$cfg" ]; then
        echo "Quickshell config not found: $cfg" >&2
        exit 1
      fi

      export QML2_IMPORT_PATH="${qmlImportPath}:''${QML2_IMPORT_PATH:-}"
      export QT_LOGGING_RULES="qt.qpa.theme.gnome.warning=false;''${QT_LOGGING_RULES:-}"
      export QT_QUICK_CONTROLS_STYLE="Basic"

      if ${pkgs.systemd}/bin/systemctl --user --quiet is-active qs-app-launcher.service; then
        exec quickshell ipc -c app-launcher call launcher toggle
      fi

      ${pkgs.systemd}/bin/systemctl --user start qs-app-launcher.service

      for _ in $(seq 1 40); do
        if quickshell ipc -c app-launcher call launcher show >/dev/null 2>&1; then
          exit 0
        fi
        sleep 0.05
      done

      echo "qs-app-launcher service did not become ready in time" >&2
      exit 1
    '';
  };
  qsPowerMenu = mkQsRunner "qs-power-menu" "powermenu/shell.qml";
  qsWallpaperPicker = mkQsRunner "qs-wallpaper-picker" "wallpaper-picker/shell.qml";
  qsSystemDashboard = mkQsRunner "qs-system-dashboard" "system-dashboard/SystemDashboard.qml";
in
{
  # Quickshell runtime with on-demand widgets (no background shell service).
  programs.quickshell = {
    enable = true;
    systemd.enable = false;
  };

  systemd.user.services.qs-app-launcher = {
    Unit = {
      Description = "Quickshell app launcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell --config app-launcher";
      Restart = "on-failure";
      RestartSec = 1;
      Environment = [
        "QML2_IMPORT_PATH=${qmlImportPath}"
        "QT_LOGGING_RULES=qt.qpa.theme.gnome.warning=false"
        "QT_QUICK_CONTROLS_STYLE=Basic"
      ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  home.packages = with pkgs; [
    qt6.qtdeclarative
    qt6.qt5compat
    qt6.qtwayland
    qt6.qtsvg
    qt6.qtimageformats
    qsAppLauncher
    qsPowerMenu
    qsWallpaperPicker
    qsSystemDashboard
  ];

  xdg.configFile."quickshell/app-launcher/shell.qml".text = ''
    import QtQuick
    import QtQuick.Controls
    import QtQuick.Layouts
    import "file://${config.home.homeDirectory}/.config/stalbar-theme/generated" as RuntimeTheme
    import Quickshell
    import Quickshell.Io
    import Quickshell.Wayland
    import Quickshell.Widgets

    ShellRoot {
        id: shell
        readonly property var theme: RuntimeTheme.QuickshellTheme

        property int selectedIndex: 0
        property bool open: false
        property string query: ""
        property var allApps: []
        property bool appsReady: false
        property int maxInitialResults: 24
        property int maxSearchResults: 48

        Component.onCompleted: Qt.callLater(reloadApplications)

        function textOrEmpty(v) {
            return v === undefined || v === null ? "" : String(v);
        }

        function appName(entry) {
            const name = textOrEmpty(entry.name).trim();
            if (name.length > 0)
                return name;
            return textOrEmpty(entry.id).replace(".desktop", "");
        }

        function appIcon(entry) {
            const icon = textOrEmpty(entry.icon).trim();
            if (icon.length > 0)
                return Quickshell.iconPath(icon, "application-x-executable");
            const byId = textOrEmpty(entry.id).replace(/\.desktop$/i, "");
            if (byId.length > 0)
                return Quickshell.iconPath(byId, "application-x-executable");
            return Quickshell.iconPath("application-x-executable", "application-x-executable");
        }

        function appScore(app, q) {
            if (!q)
                return 0;
            const name = app.nameLower;
            const id = app.idLower;
            let score = 0;
            if (name.startsWith(q))
                score += 1000;
            const i1 = name.indexOf(q);
            if (i1 >= 0)
                score += 600 - i1;
            const i2 = id.indexOf(q);
            if (i2 >= 0)
                score += 260 - i2;
            return score;
        }

        function makeAppRecord(entry) {
            const name = appName(entry);
            const generic = textOrEmpty(entry.genericName);
            const id = textOrEmpty(entry.id);
            const keywords = (entry.keywords || []).join(" ");
            return {
                entry: entry,
                name: name,
                nameLower: name.toLowerCase(),
                id: id,
                idLower: id.toLowerCase(),
                haystack: (name + " " + generic + " " + keywords + " " + id).toLowerCase(),
                icon: appIcon(entry)
            };
        }

        function reloadApplications() {
            const raw = (typeof DesktopEntries.applications.values === "function")
              ? Array.from(DesktopEntries.applications.values())
              : Array.from(DesktopEntries.applications.values || []);
            const apps = [];
            for (let i = 0; i < raw.length; i++) {
                const entry = raw[i];
                if (!entry || entry.noDisplay)
                    continue;
                apps.push(makeAppRecord(entry));
            }
            apps.sort((a, b) => a.name.localeCompare(b.name));
            allApps = apps;
            appsReady = true;
        }

        function resetState() {
            query = "";
            selectedIndex = 0;
        }

        function show() {
            resetState();
            open = true;
        }

        function hide() {
            open = false;
            resetState();
        }

        function toggle() {
            if (open)
                hide();
            else
                show();
        }

        function launch(entry) {
            if (!entry)
                return;
            entry.entry.execute();
            hide();
        }

        Connections {
            target: DesktopEntries

            function onApplicationsChanged() {
                Qt.callLater(shell.reloadApplications);
            }
        }

        IpcHandler {
            enabled: true
            target: "launcher"

            function toggle() {
                shell.toggle();
            }

            function show() {
                shell.show();
            }

            function hide() {
                shell.hide();
            }
        }

        Variants {
            id: root
            model: Quickshell.screens

            PanelWindow {
                id: win
                required property var modelData
                screen: modelData
                visible: shell.open || win.progress > 0.01

                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                anchors {
                    top: true
                    right: true
                    bottom: true
                    left: true
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:launcher"
                WlrLayershell.keyboardFocus: shell.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                property real progress: shell.open ? 1 : 0
                Behavior on progress {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }

                ScriptModel {
                    id: results

                    values: {
                        if (!shell.appsReady)
                            return [];

                        const all = shell.allApps;

                        const q = shell.query.trim().toLowerCase();
                        if (!q)
                            return all.slice(0, shell.maxInitialResults);

                        const matches = [];
                        for (let i = 0; i < all.length; i++) {
                            const app = all[i];
                            if (app.haystack.indexOf(q) < 0)
                                continue;
                            matches.push({
                                app: app,
                                score: shell.appScore(app, q)
                            });
                        }

                        matches.sort((a, b) => b.score - a.score);
                        const top = [];
                        for (let i = 0; i < matches.length && i < shell.maxSearchResults; i++)
                            top.push(matches[i].app);
                        return top;
                    }

                    onValuesChanged: {
                        const count = values ? values.length : 0;
                        if (count <= 0) {
                            shell.selectedIndex = 0;
                            return;
                        }
                        if (shell.selectedIndex >= count)
                            shell.selectedIndex = count - 1;
                        if (shell.selectedIndex < 0)
                            shell.selectedIndex = 0;
                    }
                }

                Item {
                    anchors.fill: parent
                    opacity: win.progress
                    visible: win.progress > 0.01
                    enabled: visible

                FocusScope {
                    anchors.fill: parent
                    focus: shell.open
                    Keys.priority: Keys.BeforeItem

                    onActiveFocusChanged: {
                        if (activeFocus && shell.open)
                            Qt.callLater(() => search.forceActiveFocus());
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            shell.hide();
                            event.accepted = true;
                            return;
                        }

                        if (event.key === Qt.Key_Down) {
                            const count = results.values ? results.values.length : 0;
                            if (count > 0)
                                shell.selectedIndex = Math.min(shell.selectedIndex + 1, count - 1);
                            list.positionViewAtIndex(shell.selectedIndex, ListView.Contain);
                            event.accepted = true;
                            return;
                        }

                        if (event.key === Qt.Key_Up) {
                            if (results.values && results.values.length > 0)
                                shell.selectedIndex = Math.max(shell.selectedIndex - 1, 0);
                            list.positionViewAtIndex(shell.selectedIndex, ListView.Contain);
                            event.accepted = true;
                            return;
                        }

                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            const entry = results.values ? results.values[shell.selectedIndex] : null;
                            if (entry)
                                shell.launch(entry);
                            event.accepted = true;
                        }
                    }

                        Rectangle {
                            anchors.fill: parent
                            color: shell.theme.overlay
                        }

                        MouseArea {
                            id: dismissArea
                            anchors.fill: parent
                            onPressed: mouse => {
                            const p = panel.mapFromItem(dismissArea, mouse.x, mouse.y);
                            const outside = (p.x < 0 || p.y < 0 || p.x > panel.width || p.y > panel.height);
                            if (outside)
                                shell.hide();
                            mouse.accepted = outside;
                        }
                    }

                        Rectangle {
                            id: panel
                            width: 552
                            height: 404
                            anchors.centerIn: parent
                            radius: 22
                            color: shell.theme.panel
                            border.width: 1
                            border.color: shell.theme.panelBorder
                            clip: true
                            scale: 0.97 + (0.03 * win.progress)

                            Behavior on scale {
                                NumberAnimation {
                                    duration: 120
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 1
                                radius: parent.radius - 1
                                color: shell.theme.panelRaised
                                border.width: 1
                                border.color: shell.theme.panelMutedBorder
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 10

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8

                                    Text {
                                        text: "Launch"
                                        color: shell.theme.text
                                        font.family: "JetBrainsMono Nerd Font Mono"
                                        font.pixelSize: 14
                                        font.weight: Font.DemiBold
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: results.values ? String(results.values.length) : "0"
                                        color: shell.theme.textMuted
                                        font.family: "JetBrainsMono Nerd Font Mono"
                                        font.pixelSize: 12
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 44
                                    radius: 14
                                    color: shell.theme.field
                                    border.width: 1
                                    border.color: shell.theme.fieldBorder

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 8

                                        Text {
                                            text: "󰍉"
                                            color: shell.theme.fieldMuted
                                            font.family: "JetBrainsMono Nerd Font Mono"
                                            font.pixelSize: 18
                                        }

                                        TextField {
                                            id: search
                                            Layout.fillWidth: true
                                            text: shell.query
                                            placeholderText: "Search apps"
                                            color: shell.theme.fieldText
                                            placeholderTextColor: shell.theme.fieldMuted
                                            background: null
                                            font.family: "JetBrainsMono Nerd Font Mono"
                                            font.pixelSize: 16
                                            selectByMouse: true

                                            onTextChanged: {
                                                if (shell.query === text)
                                                    return;
                                                shell.query = text;
                                                shell.selectedIndex = 0;
                                                list.positionViewAtBeginning();
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    radius: 16
                                    color: shell.theme.listBg
                                    border.width: 1
                                    border.color: shell.theme.listBorder

                                    ListView {
                                        id: list
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        clip: true
                                        spacing: 4
                                        highlight: null
                                        model: results.values
                                        currentIndex: shell.selectedIndex
                                        cacheBuffer: 120
                                        reuseItems: true

                                        delegate: Rectangle {
                                            required property var modelData
                                            required property int index
                                            property int rowIndex: index
                                            property bool hovered: false

                                        width: list.width
                                        height: 50
                                        color: rowIndex === shell.selectedIndex
                                          ? shell.theme.rowActive
                                          : hovered
                                            ? shell.theme.rowHover
                                            : shell.theme.rowIdle
                                        radius: 14

                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.leftMargin: 12
                                                anchors.rightMargin: 12
                                                spacing: 12

                                                IconImage {
                                                    Layout.minimumWidth: 28
                                                    Layout.preferredWidth: 28
                                                    Layout.maximumWidth: 28
                                                    Layout.minimumHeight: 28
                                                    Layout.preferredHeight: 28
                                                    Layout.maximumHeight: 28
                                                    source: modelData.icon
                                                    smooth: true
                                                }

                                                Text {
                                                    Layout.fillWidth: true
                                                    text: modelData.name
                                                    color: shell.theme.text
                                                    elide: Text.ElideRight
                                                    font.family: "JetBrainsMono Nerd Font Mono"
                                                    font.pixelSize: 15
                                                }
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onEntered: {
                                                    parent.hovered = true;
                                                    shell.selectedIndex = rowIndex;
                                                }
                                                onExited: parent.hovered = false
                                                onClicked: shell.launch(modelData)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
  '';

  xdg.configFile."quickshell/powermenu/shell.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import "file://${config.home.homeDirectory}/.config/stalbar-theme/generated" as RuntimeTheme
    import Quickshell
    import Quickshell.Wayland

    ShellRoot {
        readonly property var theme: RuntimeTheme.QuickshellTheme
        Variants {
            id: root
            model: Quickshell.screens

            readonly property var actions: [
                {
                    key: Qt.Key_L,
                    label: "Lock",
                    icon: "󰌾",
                    command: "command -v hyprlock >/dev/null 2>&1 && hyprlock || loginctl lock-session"
                },
                {
                    key: Qt.Key_E,
                    label: "Logout",
                    icon: "󰍃",
                    command: "hyprctl dispatch exit"
                },
                {
                    key: Qt.Key_R,
                    label: "Reboot",
                    icon: "󰜉",
                    command: "systemctl reboot"
                },
                {
                    key: Qt.Key_P,
                    label: "Shutdown",
                    icon: "󰐥",
                    command: "systemctl poweroff"
                }
            ]

            property bool open: true
            property bool quitting: false

            PanelWindow {
                id: win
                required property var modelData
                screen: modelData

                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                anchors {
                    top: true
                    right: true
                    bottom: true
                    left: true
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:powermenu"
                WlrLayershell.keyboardFocus: root.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                property real progress: root.open ? 1 : 0
                Behavior on progress {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }

                Timer {
                    id: quitTimer
                    interval: 90
                    repeat: false
                    onTriggered: Qt.quit()
                }

                function closeAndQuit() {
                    if (root.quitting)
                        return;
                    root.quitting = true;
                    root.open = false;
                    quitTimer.start();
                }

                function runAction(command) {
                    Quickshell.execDetached(["sh", "-c", command]);
                    closeAndQuit();
                }

                function handleKey(key) {
                    if (key === Qt.Key_Escape) {
                        closeAndQuit();
                        return true;
                    }

                    for (let i = 0; i < root.actions.length; i++) {
                        const action = root.actions[i];
                        if (action.key === key) {
                            runAction(action.command);
                            return true;
                        }
                    }
                    return false;
                }

                Item {
                    anchors.fill: parent
                    opacity: win.progress
                    visible: win.progress > 0.01
                    enabled: visible

                    FocusScope {
                        anchors.fill: parent
                        focus: root.open

                        Keys.onPressed: event => {
                            if (win.handleKey(event.key))
                                event.accepted = true;
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: theme.overlay
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: win.closeAndQuit()
                        }

                        Rectangle {
                            id: panel
                            width: 500
                            height: 190
                            anchors.centerIn: parent
                            radius: 24
                            color: theme.panel
                            border.width: 1
                            border.color: theme.panelBorder
                            opacity: win.progress
                            clip: true
                            scale: 0.97 + (0.03 * win.progress)

                            Behavior on scale {
                                NumberAnimation {
                                    duration: 120
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 1
                                radius: parent.radius - 1
                                color: theme.panelRaised
                                border.width: 1
                                border.color: theme.panelMutedBorder
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 10

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8

                                    Text {
                                        text: "Session"
                                        color: theme.text
                                        font.family: "JetBrainsMono Nerd Font Mono"
                                        font.pixelSize: 14
                                        font.weight: Font.DemiBold
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: "Esc to close"
                                        color: theme.textMuted
                                        font.family: "JetBrainsMono Nerd Font Mono"
                                        font.pixelSize: 11
                                    }
                                }

                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.fillWidth: true
                                    spacing: 10

                                    Repeater {
                                        model: root.actions

                                        delegate: Item {
                                            id: actionItem
                                            required property var modelData
                                            property bool hovered: false

                                            width: 112
                                            height: 126

                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 18
                                                color: actionItem.hovered
                                                  ? theme.actionHover
                                                  : theme.actionIdle
                                                border.width: 1
                                                border.color: theme.actionBorder

                                                Behavior on color {
                                                    ColorAnimation { duration: 100 }
                                                }
                                            }

                                            Column {
                                                anchors.centerIn: parent
                                                spacing: 10

                                                Rectangle {
                                                    id: circle
                                                    width: 72
                                                    height: 72
                                                    radius: 36
                                                    color: actionItem.hovered
                                                      ? theme.accentSoft
                                                      : theme.panel
                                                    border.width: 1
                                                    border.color: theme.panelBorder

                                                    Behavior on color {
                                                        ColorAnimation { duration: 100 }
                                                    }

                                                    Text {
                                                        anchors.centerIn: parent
                                                        text: modelData.icon
                                                        color: theme.text
                                                        font.family: "JetBrainsMono Nerd Font Mono"
                                                        font.pixelSize: 32
                                                        font.weight: Font.DemiBold
                                                    }
                                                }

                                                Text {
                                                    anchors.horizontalCenter: circle.horizontalCenter
                                                    text: modelData.label
                                                    color: theme.text
                                                    font.family: "JetBrainsMono Nerd Font Mono"
                                                    font.pixelSize: 14
                                                    font.weight: Font.Medium
                                                }
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onEntered: parent.hovered = true
                                                onExited: parent.hovered = false
                                                onClicked: win.runAction(modelData.command)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
  '';

  xdg.configFile."quickshell/README.md".text = ''
    Quickshell staging is enabled in Nix.

    Current helper commands:
    - qs-app-launcher (used by ALT+SPACE)
    - qs-power-menu (used by SUPER+M)
    - qs-wallpaper-picker
    - qs-system-dashboard

    Put your widget configs in:
    ~/.config/quickshell/
  '';
}
