{ pkgs, nord, ... }:

{
  home.packages = [
    pkgs.wlogout
  ];

  xdg.configFile."wlogout/layout".text = ''
    {
      "label" : "lock",
      "action" : "hyprlock",
      "text" : "Lock",
      "keybind" : "l"
    }
    {
      "label" : "logout",
      "action" : "hyprctl dispatch exit",
      "text" : "Logout",
      "keybind" : "e"
    }
    {
      "label" : "suspend",
      "action" : "systemctl suspend",
      "text" : "Suspend",
      "keybind" : "u"
    }
    {
      "label" : "reboot",
      "action" : "systemctl reboot",
      "text" : "Reboot",
      "keybind" : "r"
    }
    {
      "label" : "shutdown",
      "action" : "systemctl poweroff",
      "text" : "Shutdown",
      "keybind" : "s"
    }
  '';

  xdg.configFile."wlogout/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font Mono", "JetBrains Mono", monospace;
      font-size: 15px;
      font-weight: 700;
      color: #${nord.nord4};
      transition: none;
    }

    window {
      background-color: rgba(46, 52, 64, 0.48);
    }

    button {
      background-color: rgba(59, 66, 82, 0.92);
      border: 1px solid rgba(76, 86, 106, 0.95);
      border-radius: 18px;
      margin: 12px;
      min-width: 126px;
      min-height: 136px;
      max-width: 126px;
      max-height: 136px;
      padding: 86px 8px 12px;
      box-shadow: none;
      background-repeat: no-repeat;
      background-position: center 30px;
      background-size: 34%;
    }

    button label {
      margin: 0;
      padding: 0;
      font-size: 16px;
      font-weight: 700;
      color: #${nord.nord4};
    }

    button:focus,
    button:active,
    button:hover {
      background-color: rgba(94, 129, 172, 0.95);
      border-color: #${nord.nord9};
      color: #${nord.nord6};
      box-shadow: none;
      outline: none;
    }

    #lock {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
    }

    #logout {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
    }

    #suspend {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
    }

    #reboot {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
    }

    #shutdown {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      border-color: rgba(191, 97, 106, 0.75);
    }
  '';
}
