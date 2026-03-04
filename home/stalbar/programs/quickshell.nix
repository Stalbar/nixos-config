{ lib, pkgs, ... }:

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
        exec quickshell --path "$cfg"
      '';
    };

  qsAppLauncher = mkQsRunner "qs-app-launcher" "app-launcher/shell.qml";
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
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Widgets

    ShellRoot {
        Variants {
            id: root
            model: Quickshell.screens

            property int selectedIndex: 0
            property bool open: true
            property bool quitting: false
            property string query: ""

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

            function appHaystack(entry) {
                const name = textOrEmpty(entry.name).toLowerCase();
                const generic = textOrEmpty(entry.genericName).toLowerCase();
                const id = textOrEmpty(entry.id).toLowerCase();
                const keywords = (entry.keywords || []).join(" ").toLowerCase();
                return name + " " + generic + " " + keywords + " " + id;
            }

            function appScore(entry, q) {
                if (!q)
                    return 0;
                const name = textOrEmpty(entry.name).toLowerCase();
                const id = textOrEmpty(entry.id).toLowerCase();
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

            function closeAndQuit() {
                if (quitting)
                    return;
                quitting = true;
                Qt.quit();
            }

            function launch(entry) {
                if (!entry)
                    return;
                entry.execute();
                closeAndQuit();
            }

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
                WlrLayershell.namespace: "quickshell:launcher"
                WlrLayershell.keyboardFocus: root.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                property real progress: root.open ? 1 : 0
                Behavior on progress {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }

                ScriptModel {
                    id: results

                    values: {
                        const all0 = (typeof DesktopEntries.applications.values === "function")
                          ? Array.from(DesktopEntries.applications.values())
                          : Array.from(DesktopEntries.applications.values || []);
                        const all = [];
                        for (let i = 0; i < all0.length; i++) {
                            const entry = all0[i];
                            if (!entry || entry.noDisplay)
                                continue;
                            all.push(entry);
                        }

                        const q = root.query.trim().toLowerCase();
                        if (!q) {
                            all.sort((a, b) => root.appName(a).localeCompare(root.appName(b)));
                            return all.slice(0, 80);
                        }

                        const matches = [];
                        for (let i = 0; i < all.length; i++) {
                            const entry = all[i];
                            if (root.appHaystack(entry).indexOf(q) < 0)
                                continue;
                            matches.push({
                                entry: entry,
                                score: root.appScore(entry, q)
                            });
                        }

                        matches.sort((a, b) => b.score - a.score);
                        const top = [];
                        for (let i = 0; i < matches.length && i < 80; i++)
                            top.push(matches[i].entry);
                        return top;
                    }

                    onValuesChanged: {
                        const count = values ? values.length : 0;
                        if (count <= 0) {
                            root.selectedIndex = 0;
                            return;
                        }
                        if (root.selectedIndex >= count)
                            root.selectedIndex = count - 1;
                        if (root.selectedIndex < 0)
                            root.selectedIndex = 0;
                    }
                }

                Item {
                    anchors.fill: parent
                    opacity: win.progress
                    visible: win.progress > 0.01
                    enabled: visible

                    FocusScope {
                        anchors.fill: parent
                        focus: root.open
                        Keys.priority: Keys.BeforeItem

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Escape) {
                                root.closeAndQuit();
                                event.accepted = true;
                                return;
                            }

                            if (event.key === Qt.Key_Down) {
                                const count = results.values ? results.values.length : 0;
                                if (count > 0)
                                    root.selectedIndex = Math.min(root.selectedIndex + 1, count - 1);
                                list.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                                event.accepted = true;
                                return;
                            }

                            if (event.key === Qt.Key_Up) {
                                if (results.values && results.values.length > 0)
                                    root.selectedIndex = Math.max(root.selectedIndex - 1, 0);
                                list.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                                event.accepted = true;
                                return;
                            }

                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                const entry = results.values ? results.values[root.selectedIndex] : null;
                                if (entry)
                                    root.launch(entry);
                                event.accepted = true;
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: Qt.rgba(0.18, 0.20, 0.25, 0.52)
                        }

                        MouseArea {
                            id: dismissArea
                            anchors.fill: parent
                            onPressed: mouse => {
                                const p = panel.mapFromItem(dismissArea, mouse.x, mouse.y);
                                const outside = (p.x < 0 || p.y < 0 || p.x > panel.width || p.y > panel.height);
                                if (outside)
                                    root.closeAndQuit();
                                mouse.accepted = outside;
                            }
                        }

                        Rectangle {
                            id: panel
                            width: 620
                            height: 470
                            anchors.centerIn: parent
                            radius: 16
                            color: Qt.rgba(0.18, 0.20, 0.25, 0.94)
                            border.width: 1
                            border.color: Qt.rgba(0.30, 0.34, 0.42, 0.86)
                            scale: 0.985 + (0.015 * win.progress)

                            Behavior on scale {
                                NumberAnimation {
                                    duration: 120
                                    easing.type: Easing.OutCubic
                                }
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 10

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 48
                                    radius: 12
                                    color: "#ECEFF4"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 8

                                        Text {
                                            text: "󰍉"
                                            color: "#4C566A"
                                            font.family: "JetBrainsMono Nerd Font Mono"
                                            font.pixelSize: 18
                                        }

                                        TextField {
                                            id: search
                                            Layout.fillWidth: true
                                            text: root.query
                                            placeholderText: "Search apps"
                                            color: "#2E3440"
                                            placeholderTextColor: "#4C566A"
                                            background: null
                                            font.family: "JetBrainsMono Nerd Font Mono"
                                            font.pixelSize: 16
                                            selectByMouse: true

                                            Component.onCompleted: forceActiveFocus()

                                            onTextEdited: {
                                                root.query = text;
                                                root.selectedIndex = 0;
                                                list.positionViewAtBeginning();
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    radius: 12
                                    color: "#2E3440"

                                    ListView {
                                        id: list
                                        anchors.fill: parent
                                        anchors.margins: 2
                                        clip: true
                                        spacing: 1
                                        highlight: null
                                        model: results.values
                                        currentIndex: root.selectedIndex

                                        delegate: Rectangle {
                                            required property var modelData
                                            required property int index
                                            property int rowIndex: index

                                            width: list.width
                                            height: 58
                                            color: rowIndex === root.selectedIndex
                                              ? "#4C566A"
                                              : "#3B4252"

                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.leftMargin: 14
                                                anchors.rightMargin: 12
                                                spacing: 12

                                                IconImage {
                                                    Layout.minimumWidth: 30
                                                    Layout.preferredWidth: 30
                                                    Layout.maximumWidth: 30
                                                    Layout.minimumHeight: 30
                                                    Layout.preferredHeight: 30
                                                    Layout.maximumHeight: 30
                                                    source: root.appIcon(modelData)
                                                    smooth: true
                                                    mipmap: true
                                                }

                                                Text {
                                                    Layout.fillWidth: true
                                                    text: root.appName(modelData)
                                                    color: "#D8DEE9"
                                                    elide: Text.ElideRight
                                                    font.family: "JetBrainsMono Nerd Font Mono"
                                                    font.pixelSize: 16
                                                }
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onEntered: root.selectedIndex = rowIndex
                                                onClicked: root.launch(modelData)
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
    import Quickshell
    import Quickshell.Wayland

    ShellRoot {
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
                            color: Qt.rgba(0.18, 0.20, 0.25, 0.55)
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: win.closeAndQuit()
                        }

                        Rectangle {
                            id: panel
                            width: 648
                            height: 238
                            anchors.centerIn: parent
                            radius: 20
                            color: Qt.rgba(0.18, 0.20, 0.25, 0.94)
                            border.width: 1
                            border.color: Qt.rgba(0.30, 0.34, 0.42, 0.88)
                            opacity: win.progress
                            scale: 0.985 + (0.015 * win.progress)

                            Behavior on scale {
                                NumberAnimation {
                                    duration: 120
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Row {
                                anchors.centerIn: parent
                                spacing: 18

                                Repeater {
                                    model: root.actions

                                    delegate: Item {
                                        id: actionItem
                                        required property var modelData
                                        property bool hovered: false

                                        width: 138
                                        height: 182

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 14

                                            Rectangle {
                                                id: circle
                                                width: 100
                                                height: 100
                                                radius: 50
                                                color: actionItem.hovered
                                                  ? Qt.rgba(0.37, 0.51, 0.67, 0.44)
                                                  : Qt.rgba(0.23, 0.29, 0.37, 0.72)

                                                Behavior on color {
                                                    ColorAnimation { duration: 100 }
                                                }

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: modelData.icon
                                                    color: "#D8DEE9"
                                                    font.family: "JetBrainsMono Nerd Font Mono"
                                                    font.pixelSize: 42
                                                    font.weight: Font.DemiBold
                                                }
                                            }

                                            Text {
                                                anchors.horizontalCenter: circle.horizontalCenter
                                                text: modelData.label
                                                color: "#D8DEE9"
                                                font.family: "JetBrainsMono Nerd Font Mono"
                                                font.pixelSize: 16
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
