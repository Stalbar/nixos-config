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
    lockSession
    logoutSession
  ];

  # Main Unified Quickshell Entrypoint (~/.config/quickshell/shell.qml)
  xdg.configFile."quickshell/shell.qml".text = ''
    import QtQuick
    import QtQuick.Controls
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Widgets
    import Quickshell.Wayland
    import Quickshell.Hyprland
    import Quickshell.Services.Mpris
    import Quickshell.Services.SystemTray
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
            "yellow": "${colors.yellow}",
            "blue": "${colors.blue}",
            "comment": "${colors.comment}"
        }

        property bool launcherOpen: false
        property bool actionCenterOpen: false
        property bool powerMenuOpen: false
        property bool osdVisible: false
        property string osdIcon: "󰕾"
        property int osdValue: 50

        // System Metrics & Status Properties
        property int cpuUsage: 0
        property int ramUsage: 0
        property bool vpnConnected: false
        property bool wifiConnected: true
        property bool micMuted: false
        property bool audioMuted: false
        property bool isHeadphones: false
        property int volumeLevel: 65

        // Notification Store
        property var notificationList: []

        // IPC Handlers for Hotkeys & Click Targets
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
            target: "powermenu"
            function toggle() { shell.powerMenuOpen = !shell.powerMenuOpen; }
            function show() { shell.powerMenuOpen = true; }
            function hide() { shell.powerMenuOpen = false; }
        }

        IpcHandler {
            enabled: true
            target: "osd"
            function showVolume(val: int) {
                shell.osdIcon = shell.getAudioIcon();
                shell.osdValue = val;
                shell.volumeLevel = val;
                shell.osdVisible = true;
                osdTimer.restart();
            }
            function showBrightness(val: int) {
                shell.osdIcon = "󰌵";
                shell.osdValue = val;
                shell.osdVisible = true;
                osdTimer.restart();
            }
        }

        IpcHandler {
            enabled: true
            target: "notify"
            function add(title: string, body: string) {
                const list = shell.notificationList.slice();
                list.unshift({ title: title, body: body, time: Qt.formatDateTime(new Date(), "HH:mm") });
                shell.notificationList = list;
            }
        }

        Timer {
            id: osdTimer
            interval: 1500
            onTriggered: shell.osdVisible = false
        }

        // System Metrics Polling Timer
        Timer {
            interval: 2500
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                sysCheckProcess.running = true;
            }
        }

        Process {
            id: sysCheckProcess
            command: ["bash", "-c", "echo CPU:$(top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d. -f1 2>/dev/null || echo 12); echo RAM:$(free -m | awk '/Mem:/ {printf \"%d\", $3/$2*100}'); echo VPN:$(ip link show 2>/dev/null | grep -E 'tun|wg' >/dev/null && echo 1 || echo 0); echo WIFI:$(ip route get 1.1.1.1 2>/dev/null | grep -v unreachable >/dev/null && echo 1 || echo 0); echo HEADPHONES:$(wpctl status 2>/dev/null | grep -iE 'headphone|headset' >/dev/null && echo 1 || echo 0)"]
            stdout: SplitParser {
                onRead: data => {
                    const str = data.trim();
                    if (str.startsWith("CPU:")) shell.cpuUsage = parseInt(str.substring(4)) || 10;
                    else if (str.startsWith("RAM:")) shell.ramUsage = parseInt(str.substring(4)) || 42;
                    else if (str.startsWith("VPN:")) shell.vpnConnected = (str.substring(4) === "1");
                    else if (str.startsWith("WIFI:")) shell.wifiConnected = (str.substring(5) === "1");
                    else if (str.startsWith("HEADPHONES:")) shell.isHeadphones = (str.substring(11) === "1");
                }
            }
        }

        function getAudioIcon() {
            if (shell.audioMuted) return "󰝟";
            if (shell.isHeadphones) return "󰋋";
            if (shell.volumeLevel > 66) return "󰕾";
            if (shell.volumeLevel > 33) return "󰖀";
            return "󰕿";
        }

        // -------------------------------------------------------------
        // 1. MAIN STATUS BAR (Workspaces + Running Apps Tray: CLEAN ICONS ONLY)
        // -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                id: barWin
                required property var modelData
                screen: modelData

                implicitHeight: 32
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
                    spacing: 14

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

                        // Virtual Desktops (Only show used / existing workspaces)
                        Repeater {
                            model: {
                                if (Hyprland.workspaces && Hyprland.workspaces.values) {
                                    const ws = Array.from(Hyprland.workspaces.values)
                                        .filter(w => w && w.id > 0)
                                        .sort((a, b) => a.id - b.id);
                                    if (ws.length > 0) return ws;
                                }
                                return [{ id: 1 }];
                            }
                            Rectangle {
                                required property var modelData
                                readonly property int wsId: modelData.id
                                readonly property bool isActive: Hyprland.focusedWorkspace ? (Hyprland.focusedWorkspace.id === wsId) : (wsId === 1)
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
                                    text: String(parent.wsId)
                                    color: parent.isActive ? shell.colors.bg : shell.colors.fg
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: "JetBrains Mono Nerd Font"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ workspace = " + String(parent.wsId) + " })"])
                                }
                            }
                        }

                        Rectangle {
                            width: 1
                            height: 14
                            color: shell.colors.comment
                        }

                        // Running Applications Tray: CLEAN ICONS ONLY (No text, no individual borders)
                        RowLayout {
                            spacing: 8
                            Repeater {
                                model: {
                                    if (Hyprland.toplevels && Hyprland.toplevels.values) {
                                        return Array.from(Hyprland.toplevels.values).filter(c => c && (c.initialClass || c.class || c.title));
                                    }
                                    return [];
                                }
                                IconImage {
                                    required property var modelData
                                    source: {
                                        const cls = (modelData.initialClass || modelData.class || "").toLowerCase();
                                        if (cls.includes("foot")) return "image://icon/foot";
                                        if (cls.includes("zen")) return "image://icon/zen-browser";
                                        if (cls.includes("chrom")) return "image://icon/chromium";
                                        if (cls.includes("code") || cls.includes("zed")) return "image://icon/zed";
                                        if (cls.includes("neovide") || cls.includes("nvim")) return "image://icon/neovide";
                                        if (cls.includes("obsidian")) return "image://icon/obsidian";
                                        if (cls.includes("thunar")) return "image://icon/system-file-manager";
                                        return cls ? "image://icon/" + cls : "application-x-executable";
                                    }
                                    width: 18
                                    height: 18

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (modelData.address) {
                                                Quickshell.execDetached(["hyprctl", "dispatch", "focuswindow", "address:" + modelData.address]);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    RowLayout {
                        spacing: 12

                        // Native System Tray (SNI Applets like nm-applet, blueman)
                        RowLayout {
                            spacing: 8
                            Repeater {
                                model: SystemTray.items.values
                                IconImage {
                                    required property var modelData
                                    source: modelData.icon
                                    width: 18
                                    height: 18
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: parent.modelData.activate()
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: 1
                            height: 14
                            color: shell.colors.comment
                        }

                        // Current Date & Time Aligned Near CPU Usage
                        Text {
                            id: clock
                            property string timeStr: ""
                            text: timeStr
                            color: shell.colors.cyan
                            font.pixelSize: 12
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

                        Rectangle {
                            width: 1
                            height: 14
                            color: shell.colors.comment
                        }

                        // CPU Usage %
                        RowLayout {
                            spacing: 4
                            Text {
                                text: "󰍛"
                                color: shell.colors.green
                                font.pixelSize: 13
                                font.family: "JetBrains Mono Nerd Font"
                            }
                            Text {
                                text: shell.cpuUsage + "%"
                                color: shell.colors.fg
                                font.pixelSize: 11
                                font.family: "JetBrains Mono Nerd Font"
                            }
                        }

                        // RAM Usage %
                        RowLayout {
                            spacing: 4
                            Text {
                                text: "󰘚"
                                color: shell.colors.yellow
                                font.pixelSize: 13
                                font.family: "JetBrains Mono Nerd Font"
                            }
                            Text {
                                text: shell.ramUsage + "%"
                                color: shell.colors.fg
                                font.pixelSize: 11
                                font.family: "JetBrains Mono Nerd Font"
                            }
                        }

                        // VPN Status Icon
                        Text {
                            text: shell.vpnConnected ? "󰦝" : "󰦞"
                            color: shell.vpnConnected ? shell.colors.green : shell.colors.comment
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"
                        }

                        // Wi-Fi Connected/Disconnected Icon
                        Text {
                            text: shell.wifiConnected ? "󰤨" : "󰤭"
                            color: shell.wifiConnected ? shell.colors.cyan : shell.colors.red
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.actionCenterOpen = !shell.actionCenterOpen
                            }
                        }

                        // Audio Volume & Headphone Dynamic Icon
                        Text {
                            text: shell.getAudioIcon()
                            color: shell.colors.magenta
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.actionCenterOpen = !shell.actionCenterOpen
                            }
                        }

                        // Microphone State Icon
                        Text {
                            text: shell.micMuted ? "󰍭" : "󰍬"
                            color: shell.micMuted ? shell.colors.red : shell.colors.green
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.micMuted = !shell.micMuted
                            }
                        }

                        Rectangle {
                            width: 1
                            height: 16
                            color: shell.colors.comment
                        }

                        // Power Icon
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

        // -------------------------------------------------------------
        // 2. OMNIBOX LAUNCHER (App icons, glassmorphism search)
        // -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.launcherOpen || launcherAnim.opacity > 0.01

                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:launcher"
                WlrLayershell.keyboardFocus: shell.launcherOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                Shortcut {
                    sequence: "Escape"
                    enabled: shell.launcherOpen
                    onActivated: shell.launcherOpen = false
                }

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
                                    Keys.onEscapePressed: shell.launcherOpen = false
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
                                        res.push({ entry: entry, name: name, icon: entry.icon || "application-x-executable" });
                                    }
                                    return res;
                                }
                                delegate: Rectangle {
                                    width: ListView.view.width
                                    height: 44
                                    color: "transparent"
                                    radius: 8

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 12
                                        anchors.rightMargin: 12
                                        spacing: 12

                                        IconImage {
                                            source: modelData.icon ? (modelData.icon.startsWith("/") ? modelData.icon : "image://icon/" + modelData.icon) : "application-x-executable"
                                            width: 24
                                            height: 24
                                        }

                                        Text {
                                            text: modelData.name
                                            color: shell.colors.fg
                                            font.family: "JetBrains Mono Nerd Font"
                                            font.pixelSize: 13
                                            Layout.fillWidth: true
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

        // -------------------------------------------------------------
        // 3. UNIFIED ACTION & NOTIFICATION CENTER (Mpris Media & Notifications)
        // -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.actionCenterOpen

                implicitWidth: 380
                color: shell.colors.bg

                anchors {
                    top: true
                    bottom: true
                    right: true
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:actioncenter"
                WlrLayershell.keyboardFocus: shell.actionCenterOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                Shortcut {
                    sequence: "Escape"
                    enabled: shell.actionCenterOpen
                    onActivated: shell.actionCenterOpen = false
                }

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

                    // Mpris Media Player Card (YouTube / Music)
                    Rectangle {
                        Layout.fillWidth: true
                        height: 100
                        color: "#24283b"
                        radius: 12
                        border.width: 1
                        border.color: shell.colors.magenta

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            RowLayout {
                                Text {
                                    text: "󰎆 Playing Media"
                                    color: shell.colors.cyan
                                    font.family: "JetBrains Mono Nerd Font"
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                                Item { Layout.fillWidth: true }
                                Text {
                                    text: Mpris.players.values.length > 0 ? (Mpris.players.values[0].playbackState === 1 ? "Playing" : "Paused") : "No Media"
                                    color: shell.colors.green
                                    font.family: "JetBrains Mono Nerd Font"
                                    font.pixelSize: 11
                                }
                            }

                            Text {
                                text: Mpris.players.values.length > 0 ? (Mpris.players.values[0].trackTitle || "Media Track") : "YouTube / Media Player"
                                color: shell.colors.fg
                                font.family: "JetBrains Mono Nerd Font"
                                font.pixelSize: 13
                                font.bold: true
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 20

                                Text {
                                    text: "󰒮"
                                    color: shell.colors.fg
                                    font.pixelSize: 18
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: if (Mpris.players.values.length > 0) Mpris.players.values[0].previous()
                                    }
                                }

                                Text {
                                    text: Mpris.players.values.length > 0 && Mpris.players.values[0].playbackState === 1 ? "󰏤" : "󰐊"
                                    color: shell.colors.magenta
                                    font.pixelSize: 22
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: if (Mpris.players.values.length > 0) Mpris.players.values[0].playPause()
                                    }
                                }

                                Text {
                                    text: "󰒝"
                                    color: shell.colors.fg
                                    font.pixelSize: 18
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: if (Mpris.players.values.length > 0) Mpris.players.values[0].next()
                                    }
                                }
                            }
                        }
                    }

                    // Notifications Feed
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#1f2335"
                        radius: 12
                        border.width: 1
                        border.color: shell.colors.comment

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 12

                            Text {
                                text: "Notifications"
                                color: shell.colors.cyan
                                font.family: "JetBrains Mono Nerd Font"
                                font.bold: true
                            }

                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: shell.notificationList
                                delegate: Rectangle {
                                    width: ListView.view.width
                                    height: 56
                                    color: "#24283b"
                                    radius: 8

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 8

                                        RowLayout {
                                            Text {
                                                text: modelData.title
                                                color: shell.colors.cyan
                                                font.bold: true
                                                font.pixelSize: 12
                                                Layout.fillWidth: true
                                            }
                                            Text {
                                                text: modelData.time
                                                color: shell.colors.comment
                                                font.pixelSize: 10
                                            }
                                        }
                                        Text {
                                            text: modelData.body
                                            color: shell.colors.fg
                                            font.pixelSize: 11
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // -------------------------------------------------------------
        // 4. VOLATILE OSD OVERLAY
        // -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.osdVisible

                implicitWidth: 240
                implicitHeight: 52
                color: "transparent"

                anchors {
                    bottom: true
                }
                margins {
                    bottom: 60
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

        // -------------------------------------------------------------
        // 5. POWER MENU (Ultra-compact modal)
        // -------------------------------------------------------------
        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.powerMenuOpen

                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:powermenu"
                WlrLayershell.keyboardFocus: shell.powerMenuOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                Shortcut {
                    sequence: "Escape"
                    enabled: shell.powerMenuOpen
                    onActivated: shell.powerMenuOpen = false
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#aa10121d"
                    MouseArea { anchors.fill: parent; onClicked: shell.powerMenuOpen = false }
                }

                Rectangle {
                    implicitWidth: 320
                    implicitHeight: 72
                    anchors.centerIn: parent
                    radius: 12
                    color: shell.colors.bg
                    border.width: 1
                    border.color: shell.colors.cyan

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 24

                        ColumnLayout {
                            spacing: 2
                            Text { text: "󰌾"; color: shell.colors.cyan; font.pixelSize: 22; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Lock"; color: shell.colors.fg; font.pixelSize: 10; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["lock-session"]); shell.powerMenuOpen = false; } }
                        }

                        ColumnLayout {
                            spacing: 2
                            Text { text: "󰍃"; color: shell.colors.magenta; font.pixelSize: 22; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Logout"; color: shell.colors.fg; font.pixelSize: 10; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["logout-session"]); shell.powerMenuOpen = false; } }
                        }

                        ColumnLayout {
                            spacing: 2
                            Text { text: "󰜉"; color: shell.colors.cyan; font.pixelSize: 22; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Reboot"; color: shell.colors.fg; font.pixelSize: 10; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["systemctl", "reboot"]); shell.powerMenuOpen = false; } }
                        }

                        ColumnLayout {
                            spacing: 2
                            Text { text: "󰐥"; color: shell.colors.red; font.pixelSize: 22; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Shutdown"; color: shell.colors.fg; font.pixelSize: 10; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["systemctl", "poweroff"]); shell.powerMenuOpen = false; } }
                        }
                    }
                }
            }
        }
    }
  '';
}
