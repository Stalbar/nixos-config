{ nord, ... }:

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
          "1": "#${nord.nord9}",
          "2": "#${nord.nord9}",
          "3": "#${nord.nord9}",
          "4": "#${nord.nord9}"
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
          "keyColor": "38;2;129;161;193",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "os",
          "key": "OS",
          "keyColor": "38;2;143;188;187",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "kernel",
          "key": "Kernel",
          "keyColor": "38;2;143;188;187",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "host",
          "key": "Host",
          "keyColor": "38;2;143;188;187",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "wm",
          "key": "WM",
          "keyColor": "38;2;143;188;187",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "terminal",
          "key": "Terminal",
          "keyColor": "38;2;143;188;187",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "cpu",
          "key": "CPU",
          "keyColor": "38;2;136;192;208",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "gpu",
          "key": "GPU",
          "keyColor": "38;2;136;192;208",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "memory",
          "key": "Memory",
          "keyColor": "38;2;136;192;208",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "disk",
          "key": "Disk",
          "keyColor": "38;2;136;192;208",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "battery",
          "key": "Battery",
          "keyColor": "38;2;163;190;140",
          "outputColor": "38;2;216;222;233"
        },
        {
          "type": "uptime",
          "key": "Uptime",
          "keyColor": "38;2;163;190;140",
          "outputColor": "38;2;216;222;233"
        },
        "break"
      ]
    }
  '';
}
