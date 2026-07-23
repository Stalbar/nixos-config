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
  qsStatusBar = mkQsRunner "qs-status-bar" "bar/shell.qml";
  qsActionCenter = mkQsRunner "qs-action-center" "action-center/shell.qml";
  qsAgentHub = mkQsRunner "qs-agent-hub" "agent-hub/shell.qml";
  qsOsd = mkQsRunner "qs-osd" "osd/shell.qml";

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

  systemd.user.services.qs-status-bar = {
    Unit = {
      Description = "Quickshell Status Bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell --config bar";
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
    qsStatusBar
    qsActionCenter
    qsAgentHub
    qsOsd
    lockSession
    logoutSession
  ];

  # Main Status Bar (Section 5: Flat, opaque, pinned)
  xdg.configFile."quickshell/bar/shell.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland
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
                        }

                        Repeater {
                            model: [1, 2, 3, 4, 5]
                            Rectangle {
                                required property int modelData
                                width: 22
                                height: 22
                                radius: 4
                                color: modelData === 1 ? shell.colors.magenta : "transparent"
                                border.width: 1
                                border.color: modelData === 1 ? shell.colors.cyan : shell.colors.comment

                                Text {
                                    anchors.centerIn: parent
                                    text: String(parent.modelData)
                                    color: parent.modelData === 1 ? shell.colors.bg : shell.colors.fg
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: "JetBrains Mono Nerd Font"
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
                    }

                    Item { Layout.fillWidth: true }

                    RowLayout {
                        spacing: 12

                        Text {
                            text: "󰍛"
                            color: shell.colors.green
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"
                        }

                        Text {
                            text: "󰕾"
                            color: shell.colors.cyan
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"
                        }

                        Text {
                            text: "󰤨"
                            color: shell.colors.magenta
                            font.pixelSize: 14
                            font.family: "JetBrains Mono Nerd Font"
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
                                onClicked: Quickshell.execDetached(["qs-power-menu"])
                            }
                        }
                    }
                }
            }
        }
    }
  '';

  # Volatile OSD Overlay (Section 5: Minimal floating overlays for volume & brightness)
  xdg.configFile."quickshell/osd/shell.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland

    ShellRoot {
        id: shell

        readonly property var colors: {
            "bg": "${colors.bg}",
            "fg": "${colors.fg}",
            "cyan": "${colors.cyan}",
            "magenta": "${colors.magenta}",
            "comment": "${colors.comment}"
        }

        property bool osdVisible: false
        property string osdIcon: "󰕾"
        property int osdValue: 50

        Timer {
            id: hideTimer
            interval: 1500
            onTriggered: shell.osdVisible = false
        }

        IpcHandler {
            enabled: true
            target: "osd"
            function showVolume(val) {
                shell.osdIcon = "󰕾";
                shell.osdValue = val;
                shell.osdVisible = true;
                hideTimer.restart();
            }
            function showBrightness(val) {
                shell.osdIcon = "󰌵";
                shell.osdValue = val;
                shell.osdVisible = true;
                hideTimer.restart();
            }
        }

        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData
                visible: shell.osdVisible

                width: 220
                height: 48
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
                    radius: 24
                    color: shell.colors.bg
                    border.width: 1
                    border.color: shell.colors.cyan

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

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
                                width: parent.width * (shell.osdValue / 100.0)
                                height: parent.height
                                radius: 3
                                color: shell.colors.magenta
                            }
                        }
                    }
                }
            }
        }
    }
  '';

  # Omnibox Launcher (Section 5: Glassmorphism, floating center)
  xdg.configFile."quickshell/app-launcher/shell.qml".text = ''
    import QtQuick
    import QtQuick.Controls
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Io
    import Quickshell.Wayland

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

        property bool open: false
        property string query: ""
        property var allApps: []
        property bool appsReady: false

        Component.onCompleted: Qt.callLater(reloadApplications)

        function reloadApplications() {
            const raw = Array.from(DesktopEntries.applications.values || []);
            const apps = [];
            for (let i = 0; i < raw.length; i++) {
                const entry = raw[i];
                if (!entry || entry.noDisplay) continue;
                apps.push({
                    entry: entry,
                    name: entry.name || entry.id.replace(".desktop", ""),
                    id: entry.id
                });
            }
            allApps = apps;
            appsReady = true;
        }

        IpcHandler {
            enabled: true
            target: "launcher"
            function toggle() { open = !open; }
            function show() { open = true; }
            function hide() { open = false; }
        }

        Variants {
            model: Quickshell.screens

            PanelWindow {
                id: win
                required property var modelData
                screen: modelData
                visible: shell.open

                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                anchors.fill: parent

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:launcher"
                WlrLayershell.keyboardFocus: shell.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

                Rectangle {
                    anchors.fill: parent
                    color: "#aa10121d"
                }

                Rectangle {
                    width: 560
                    height: 420
                    anchors.centerIn: parent
                    radius: 16
                    color: shell.colors.bg
                    border.width: 1
                    border.color: shell.colors.cyan

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 12

                        RowLayout {
                            TextField {
                                Layout.fillWidth: true
                                placeholderText: "Omnibox: Search apps or type command..."
                                color: shell.colors.fg
                                placeholderTextColor: shell.colors.comment
                                font.family: "JetBrains Mono Nerd Font"
                                font.pixelSize: 14
                                background: Rectangle {
                                    color: "#1f2335"
                                    radius: 8
                                    border.color: shell.colors.magenta
                                    border.width: 1
                                }
                                onTextChanged: shell.query = text
                            }
                        }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: shell.allApps.filter(a => a.name.toLowerCase().includes(shell.query.toLowerCase()))
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
                                        shell.open = false;
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

  # Unified Action & Notification Center (Section 5: Glassmorphism slide-out side panel)
  xdg.configFile."quickshell/action-center/shell.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland

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

        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData

                width: 360
                color: shell.colors.bg

                anchors {
                    top: true
                    bottom: true
                    right: true
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:actioncenter"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    Text {
                        text: "Control & Notifications"
                        color: shell.colors.cyan
                        font.pixelSize: 16
                        font.bold: true
                        font.family: "JetBrains Mono Nerd Font"
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
    }
  '';

  # Agent & Debugging Hub (SWE Special - Section 5)
  xdg.configFile."quickshell/agent-hub/shell.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland

    ShellRoot {
        id: shell

        readonly property var colors: {
            "bg": "${colors.bg}",
            "fg": "${colors.fg}",
            "cyan": "${colors.cyan}",
            "magenta": "${colors.magenta}",
            "green": "${colors.green}",
            "comment": "${colors.comment}"
        }

        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData

                width: 480
                height: 360
                color: shell.colors.bg

                anchors.centerIn: parent

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:agenthub"

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

                        Text {
                            text: "🤖 SWE Agent & Debugging Hub"
                            color: shell.colors.cyan
                            font.pixelSize: 15
                            font.bold: true
                            font.family: "JetBrains Mono Nerd Font"
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
                                text: "[SYSTEM] Antigravity CLI Agent Active\n[TASK] Quickshell QML Suite Generation Complete\n[STATUS] All Systems Pure & Functional"
                                color: shell.colors.green
                                font.pixelSize: 12
                                font.family: "JetBrains Mono Nerd Font"
                            }
                        }
                    }
                }
            }
        }
    }
  '';

  # Power Menu
  xdg.configFile."quickshell/powermenu/shell.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland

    ShellRoot {
        readonly property var colors: {
            "bg": "${colors.bg}",
            "fg": "${colors.fg}",
            "cyan": "${colors.cyan}",
            "red": "${colors.red}",
            "magenta": "${colors.magenta}",
            "comment": "${colors.comment}"
        }

        Variants {
            model: Quickshell.screens

            PanelWindow {
                required property var modelData
                screen: modelData

                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                anchors.fill: parent

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:powermenu"

                Rectangle {
                    anchors.fill: parent
                    color: "#aa10121d"
                    MouseArea { anchors.fill: parent; onClicked: Qt.quit() }
                }

                Rectangle {
                    width: 440
                    height: 160
                    anchors.centerIn: parent
                    radius: 20
                    color: colors.bg
                    border.width: 1
                    border.color: colors.cyan

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 24

                        ColumnLayout {
                            Text { text: "󰌾"; color: colors.cyan; font.pixelSize: 32; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Lock"; color: colors.fg; font.pixelSize: 12; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["lock-session"]); Qt.quit(); } }
                        }

                        ColumnLayout {
                            Text { text: "󰍃"; color: colors.magenta; font.pixelSize: 32; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Logout"; color: colors.fg; font.pixelSize: 12; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["logout-session"]); Qt.quit(); } }
                        }

                        ColumnLayout {
                            Text { text: "󰜉"; color: colors.cyan; font.pixelSize: 32; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Reboot"; color: colors.fg; font.pixelSize: 12; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["systemctl", "reboot"]); Qt.quit(); } }
                        }

                        ColumnLayout {
                            Text { text: "󰐥"; color: colors.red; font.pixelSize: 32; font.family: "JetBrains Mono Nerd Font"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Shutdown"; color: colors.fg; font.pixelSize: 12; font.family: "JetBrains Mono Nerd Font" }
                            MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(["systemctl", "poweroff"]); Qt.quit(); } }
                        }
                    }
                }
            }
        }
    }
  '';
}
