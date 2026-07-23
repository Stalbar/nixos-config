{ ... }:

let
  colors = import ../theme/colors.nix;
in
{
  xdg.configFile."fastfetch/logo.txt".text = ''
       ◢██◣   ◥███◣  ◢██◣
       ◥███◣   ◥███◣◢███◤
        ◥███◣   ◥██████◤
    ◢█████████████████◤   ◢◣
   ◢██████████████████◣  ◢██◣
        ◢███◤      ◥███◣◢███◤
       ◢███◤        ◥██████◤
◢█████████◤          ◥█████████◣
◥█████████◣          ◢█████████◤
    ◢██████◣        ◢███◤
   ◢███◤◥███◣      ◢███◤
   ◥██◤  ◥██████████████████◤
    ◥◤   ◢█████████████████◤
        ◢██████◣   ◥███◣
       ◢███◤◥███◣   ◥███◣
       ◥██◤  ◥███◣   ◥██◤
  '';

  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "source": "~/.config/fastfetch/logo.txt",
        "type": "file",
        "padding": {
          "top": 1,
          "right": 3
        },
        "color": {
          "1": "${colors.cyan}",
          "2": "${colors.cyan}",
          "3": "${colors.cyan}",
          "4": "${colors.cyan}"
        }
      },
      "display": {
        "separator": "  ",
        "key": {
          "width": 11
        }
      },
      "modules": [
        {
          "type": "title",
          "keyColor": "38;2;125;207;255",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "os",
          "key": "OS",
          "keyColor": "38;2;187;154;247",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "kernel",
          "key": "Kernel",
          "keyColor": "38;2;187;154;247",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "host",
          "key": "Host",
          "keyColor": "38;2;187;154;247",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "wm",
          "key": "WM",
          "keyColor": "38;2;187;154;247",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "terminal",
          "key": "Terminal",
          "keyColor": "38;2;187;154;247",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "cpu",
          "key": "CPU",
          "keyColor": "38;2;125;207;255",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "gpu",
          "key": "GPU",
          "keyColor": "38;2;125;207;255",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "memory",
          "key": "Memory",
          "keyColor": "38;2;125;207;255",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "disk",
          "key": "Disk",
          "keyColor": "38;2;125;207;255",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "battery",
          "key": "Battery",
          "keyColor": "38;2;158;206;106",
          "outputColor": "38;2;192;202;245"
        },
        {
          "type": "uptime",
          "key": "Uptime",
          "keyColor": "38;2;158;206;106",
          "outputColor": "38;2;192;202;245"
        },
        "break"
      ]
    }
  '';
}
