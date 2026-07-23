{
  config,
  lib,
  pkgs,
  ...
}:

let
  colors = import ../theme/colors.nix;

  qmlImportPath = lib.concatStringsSep ":" [
    "${pkgs.qt6.qtdeclarative}${pkgs.qt6.qtbase.qtQmlPrefix}"
    "${pkgs.qt6.qt5compat}${pkgs.qt6.qtbase.qtQmlPrefix}"
    "${pkgs.qt6.qtsvg}${pkgs.qt6.qtbase.qtQmlPrefix}"
    "${pkgs.qt6.qtwayland}${pkgs.qt6.qtbase.qtQmlPrefix}"
  ];

  mkQsIpcTrigger =
    name: target: action:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [
        pkgs.quickshell
        pkgs.coreutils
      ];
      text = ''
        set -euo pipefail
        cfg_file="$HOME/.config/quickshell/shell.qml"
        exec quickshell ipc -p "$cfg_file" call "${target}" "${action}"
      '';
    };

  qsAppLauncher = mkQsIpcTrigger "qs-app-launcher" "launcher" "toggle";
  qsActionCenter = mkQsIpcTrigger "qs-action-center" "actioncenter" "toggle";
  qsAgentHub = mkQsIpcTrigger "qs-agent-hub" "agenthub" "toggle";
  qsPowerMenu = mkQsIpcTrigger "qs-power-menu" "powermenu" "toggle";

  lockSession = pkgs.writeShellScriptBin "lock-session" ''
    set -eu
    if command -v hyprlock >/dev/null 2>&1 && pgrep -x Hyprland >/dev/null 2>&1; then
      exec hyprlock
    else
      exec ${pkgs.systemd}/bin/loginctl lock-session
    fi
  '';

  logoutSession = pkgs.writeShellScriptBin "logout-session" ''
    set -eu
    if pgrep -x Hyprland >/dev/null 2>&1; then
      exec ${pkgs.hyprland}/bin/hyprctl dispatch exit
    else
      exec ${pkgs.systemd}/bin/loginctl terminate-session "$XDG_SESSION_ID"
    fi
  '';
in
{
  programs.quickshell = {
    enable = true;
    systemd.enable = false;
  };

  # Unified Quickshell Background Service
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell Unified Desktop Shell Service";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell --path %h/.config/quickshell/shell.qml";
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
    qsActionCenter
    qsAgentHub
    lockSession
    logoutSession
  ];

  # Main Unified Quickshell Entrypoint (~/.config/quickshell/shell.qml)
  xdg.configFile."quickshell/shell.qml".text = ''
    import QtQuick
    import QtQuick.Controls
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Hyprland
    import Quickshell.Io

    ShellRoot {
        id: shell

        readonly property var colors: {
            "bg": "${colors.bg}",
            "fg": "${colors.fg}",
            "cyan": "${colors.cyan}",
            "magenta": "${colors.magenta}",
            "green": "${colors.green}",
            "red": "${colors.red}",
            "comment": "${colors.comment}"
        }

        property bool launcherOpen: false
        property bool actionCenterOpen: false
        property bool agentHubOpen: false
        property bool powerMenuOpen: false
        property bool osdVisible: false
        property string osdIcon: "󰕾"
        property int osdValue: 50

        # IPC Handlers for Instant Keybindings & Click Targets
        IpcHandler {
            enabled: true
            target: "launcher"
            function toggle() { shell.launcherOpen = !shell.launcherOpen; }
            function show() { shell.launcherOpen = true; }
            function hide() { shell.launcherOpen = false; }
        }

        IpcHandler {
            enabled: true
            target: "actioncenter"
            function toggle() { shell.actionCenterOpen = !shell.actionCenterOpen; }
            function show() { shell.actionCenterOpen = true; }
            function hide() { shell.actionCenterOpen = false; }
        }

        IpcHandler {
            enabled: true
            target: "agenthub"
            function toggle() { shell.agentHubOpen = !shell.agentHubOpen; }
            function show() { shell.agentHubOpen = true; }
            function hide() { shell.agentHubOpen = false; }
        }

        IpcHandler {
            enabled: true
            target: "powermenu"
            function toggle() { shell.powerMenuOpen = !shell.powerMenuOpen; }
            function show() { shell.powerMenuOpen = true; }
            function hide() { shell.powerMenuOpen = false; }
        }

        IpcHandler {
            enabled: true
            target: "osd"
            function showVolume(val) {
                shell.osdIcon = "󰕾";
                shell.osdValue = val;
                shell.osdVisible = true;
                osdTimer.restart();
            }
            function showBrightness(val) {
                shell.osdIcon = "󰌵";
                shell.osdValue = val;
                shell.osdVisible = true;
                osdTimer.restart();
            }
        }

        Timer {
            id: osdTimer
            interval: 1500
            onTriggered: shell.osdVisible = false
        }

        # -------------------------------------------------------------
        # 1. MAIN STATUS BAR (Flat, opaque, pinned top, dynamic workspaces)
        # -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                id: barWin
                required property var modelData
                screen: modelData

                height: 32
                color: shell.colors.bg

                anchors {
                    top: true
                    left: true
                    right: true
                }

                WlrLayershell.layer: WlrLayer.Top
                WlrLayershell.namespace: "quickshell:statusbar"
                WlrLayershell.exclusiveZone: 32

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12

                    RowLayout {
                        spacing: 8

                        Text {
                            text: "󱄅"
                            color: shell.colors.cyan
                            font.pixelSize: 16
                            font.family: "JetBrains Mono Nerd Font"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.launcherOpen = !shell.launcherOpen
                            }
                        }

                        Repeater {
                            model: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            Rectangle {
                                required property int modelData
                                readonly property bool isActive: Hyprland.focusedWorkspace ? (Hyprland.focusedWorkspace.id === modelData) : (modelData === 1)
                                width: isActive ? 28 : 22
                                height: 22
                                radius: 5
                                color: isActive ? shell.colors.magenta : "transparent"
                                border.width: 1
                                border.color: isActive ? shell.colors.cyan : shell.colors.comment

                                Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                                Behavior on color { ColorAnimation { duration: 180 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: String(parent.modelData)
                                    color: parent.isActive ? shell.colors.bg : shell.colors.fg
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: "JetBrains Mono Nerd Font"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Quickshell.execDetached(["hyprctl", "dispatch", "workspace", String(parent.modelData)])
                                }
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        id: clock
                        property string timeStr: ""
                        text: timeStr
                        color: shell.colors.cyan
                        font.pixelSize: 13
                        font.bold: true
                        font.family: "JetBrains Mono Nerd Font"

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            triggeredOnStart: true
                            onTriggered: {
                                clock.timeStr = Qt.formatDateTime(new Date(), "ddd d MMM  HH:mm")
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: shell.actionCenterOpen = !shell.actionCenterOpen
                        }
                    }

                    Item { Layout.fillWidth: true }

                    RowLayout {
                        spacing: 14

                        Text {
                            text: "🤖"
                            color: shell.colors.green
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.agentHubOpen = !shell.agentHubOpen
                            }
                        }

                        Text {
                            text: "󰕾"
                            color: shell.colors.cyan
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.actionCenterOpen = !shell.actionCenterOpen
                            }
                        }

                        Text {
                            text: "󰤨"
                            color: shell.colors.magenta
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.actionCenterOpen = !shell.actionCenterOpen
                            }
                        }

                        Rectangle {
                            width: 1
                            height: 16
                            color: shell.colors.comment
                        }

                        Text {
                            text: "󰐥"
                            color: shell.colors.red
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.powerMenuOpen = !shell.powerMenuOpen
                            }
                        }
                    }
                }
            }
        }

        # -------------------------------------------------------------
        # 2. OMNIBOX LAUNCHER (Glassmorphic center floating overlay)
        # -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.launcherOpen || launcherAnim.opacity > 0.01

                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                anchors.fill: parent

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:launcher"
                WlrLayershell.keyboardFocus: shell.launcherOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                Item {
                    id: launcherAnim
                    anchors.fill: parent
                    opacity: shell.launcherOpen ? 1.0 : 0.0

                    Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

                    Rectangle {
                        anchors.fill: parent
                        color: "#aa10121d"
                        MouseArea { anchors.fill: parent; onClicked: shell.launcherOpen = false }
                    }

                    Rectangle {
                        width: 560
                        height: 420
                        anchors.centerIn: parent
                        radius: 18
                        color: shell.colors.bg
                        border.width: 1
                        border.color: shell.colors.cyan
                        scale: shell.launcherOpen ? 1.0 : 0.94

                        Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 12

                            RowLayout {
                                TextField {
                                    id: launcherSearch
                                    Layout.fillWidth: true
                                    placeholderText: "Omnibox: Search desktop apps..."
                                    color: shell.colors.fg
                                    placeholderTextColor: shell.colors.comment
                                    font.family: "JetBrains Mono Nerd Font"
                                    font.pixelSize: 14
                                    focus: shell.launcherOpen
                                    background: Rectangle {
                                        color: "#1f2335"
                                        radius: 8
                                        border.color: shell.colors.magenta
                                        border.width: 1
                                    }
                                }
                            }

                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: {
                                    const raw = Array.from(DesktopEntries.applications.values || []);
                                    const q = launcherSearch.text.toLowerCase();
                                    const res = [];
                                    for (let i = 0; i < raw.length; i++) {
                                        const entry = raw[i];
                                        if (!entry || entry.noDisplay) continue;
                                        const name = entry.name || entry.id.replace(".desktop", "");
                                        if (q && !name.toLowerCase().includes(q)) continue;
                                        res.push({ entry: entry, name: name });
                                    }
                                    return res;
                                }
                                delegate: Rectangle {
                                    width: ListView.view.width
                                    height: 40
                                    color: "transparent"
                                    radius: 6

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10

                                        Text {
                                            text: modelData.name
                                            color: shell.colors.fg
                                            font.family: "JetBrains Mono Nerd Font"
                                            font.pixelSize: 13
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered: parent.color = "#24283b"
                                        onExited: parent.color = "transparent"
                                        onClicked: {
                                            modelData.entry.execute();
                                            shell.launcherOpen = false;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # -------------------------------------------------------------
        # 3. UNIFIED ACTION & NOTIFICATION CENTER (Slide-out side panel)
        # -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.actionCenterOpen

                width: 360
                color: shell.colors.bg

                anchors {
                    top: true
                    bottom: true
                    right: true
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:actioncenter"
                WlrLayershell.keyboardFocus: shell.actionCenterOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Control & Notifications"
                            color: shell.colors.cyan
                            font.pixelSize: 16
                            font.bold: true
                            font.family: "JetBrains Mono Nerd Font"
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: "✕"
                            color: shell.colors.comment
                            font.pixelSize: 14
                            MouseArea { anchors.fill: parent; onClicked: shell.actionCenterOpen = false }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: "#24283b"
                        radius: 12
                        border.width: 1
                        border.color: shell.colors.magenta

                        ColumnLayout {
                            anchors.centerIn: parent
                            Text {
                                text: "󰎆 Playing Media"
                                color: shell.colors.fg
                                font.family: "JetBrains Mono Nerd Font"
                                font.bold: true
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#1f2335"
                        radius: 12
                        border.width: 1
                        border.color: shell.colors.comment

                        Text {
                            anchors.centerIn: parent
                            text: "No New Notifications"
                            color: shell.colors.comment
                            font.family: "JetBrains Mono Nerd Font"
                        }
                    }
                }
            }
        }

        # -------------------------------------------------------------
        # 4. AGENT & DEBUGGING HUB (SWE Special)
        # -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.agentHubOpen

                width: 520
                height: 380
                color: shell.colors.bg

                anchors.centerIn: parent

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:agenthub"
                WlrLayershell.keyboardFocus: shell.agentHubOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                Rectangle {
                    anchors.fill: parent
                    radius: 16
                    color: shell.colors.bg
                    border.width: 1
                    border.color: shell.colors.magenta

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "🤖 SWE Agent & Debugging Hub"
                                color: shell.colors.cyan
                                font.pixelSize: 15
                                font.bold: true
                                font.family: "JetBrains Mono Nerd Font"
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: "✕"
                                color: shell.colors.comment
                                font.pixelSize: 14
                                MouseArea { anchors.fill: parent; onClicked: shell.agentHubOpen = false }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#16161e"
                            radius: 8
                            border.width: 1
                            border.color: shell.colors.comment

                            Text {
                                anchors.margins: 10
                                anchors.fill: parent
                                text: "[SYSTEM] Antigravity CLI Agent Active\n[IPC] Single-Daemon Quickshell IPC Service Active\n[HYPRLAND] Focused Workspace Tracking Active\n[STATUS] All Widgets Hotkey & Click Target Interactivity Ready"
                                color: shell.colors.green
                                font.pixelSize: 12
                                font.family: "JetBrains Mono Nerd Font"
                            }
                        }
                    }
                }
            }
        }

        # -------------------------------------------------------------
        # 5. VOLATILE OSD OVERLAY
        # -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.osdVisible

                width: 240
                height: 52
                color: "transparent"

                anchors {
                    bottom: true
                    bottomMargin: 60
                    horizontalCenter: true
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:osd"

                Rectangle {
                    anchors.fill: parent
                    radius: 26
                    color: shell.colors.bg
                    border.width: 1
                    border.color: shell.colors.cyan
                    opacity: shell.osdVisible ? 1.0 : 0.0
                    scale: shell.osdVisible ? 1.0 : 0.88

                    Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                    Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Text {
                            text: shell.osdIcon
                            color: shell.colors.cyan
                            font.pixelSize: 18
                            font.family: "JetBrains Mono Nerd Font"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 6
                            radius: 3
                            color: "#24283b"

                            Rectangle {
                                width: parent.width * Math.min(1.0, Math.max(0.0, shell.osdValue / 100.0))
                                height: parent.height
                                radius: 3
                                color: shell.colors.magenta

                                Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                            }
                        }
                    }
                }
            }
        }

        # -------------------------------------------------------------
        # 6. POWER MENU
        # -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.powerMenuOpen

                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                anchors.fill: parent

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:powermenu"
                WlrLayershell.keyboardFocus: shell.powerMenuOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                Rectangle {
                    anchors.fill: parent
                    color: "#aa10121d"
                    MouseArea { anchors.fill: parent; onClicked: shell.powerMenuOpen = false }
                }

                Rectangle {
                    width: 440
                    height: 160
                    anchors.centerIn: parent
                    radius: 20
                    color: shell.colors.bg
                    border.width: 1
                    border.color: shell.colors.cyan

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 24

                        ColumnLayout {
                            Text { text: "󰌾"; color: shell.colors.cyan; font.pixelSize: 32; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Lock"; color: shell.colors.fg; font.pixelSize: 12; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["lock-session"]); shell.powerMenuOpen = false; } }
                        }

                        ColumnLayout {
                            Text { text: "󰍃"; color: shell.colors.magenta; font.pixelSize: 32; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Logout"; color: shell.colors.fg; font.pixelSize: 12; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["logout-session"]); shell.powerMenuOpen = false; } }
                        }

                        ColumnLayout {
                            Text { text: "󰜉"; color: shell.colors.cyan; font.pixelSize: 32; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Reboot"; color: shell.colors.fg; font.pixelSize: 12; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["systemctl", "reboot"]); shell.powerMenuOpen = false; } }
                        }

                        ColumnLayout {
                            Text { text: "󰐥"; color: shell.colors.red; font.pixelSize: 32; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Shutdown"; color: shell.colors.fg; font.pixelSize: 12; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["systemctl", "poweroff"]); shell.powerMenuOpen = false; } }
                        }
                    }
                }
            }
        }
    }
  '';
}
