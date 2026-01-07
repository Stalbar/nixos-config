{ pkgs, ... }:

let
  myAsciiLogo = pkgs.writeText "fastfetch-logo.txt" ''
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
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
	source = "${myAsciiLogo}";
        color = {
          "1" = "blue";
          "2" = "black";
        };
        padding = {
          top = 0;
          right = 5;
        };
        height = 18;
      };

      display = {
        separator = " ▸ ";
      };

      modules = [
        "title"
        "break"
        {
          type = "custom";
          format = "┌────────────────────────────────────────────────────────────┐";
	  keyColor = "green";
        }
        {
          type = "os";
          key = "";
          keyColor = "red";
        }
        {
          type = "kernel";
          key = "";
          keyColor = "red";
        }
        {
          type = "de";
          key = "";
          keyColor = "green";
        }
        {
          type = "wm";
          key = "";
          keyColor = "green";
        }
        {
          type = "packages";
          key = "";
          keyColor = "yellow";
        }
        {
          type = "custom";
          format = "├─────────────────────────────────────────────────────────────┤";
	  keyColor = "green";
        }
        {
          type = "memory";
          key = "";
          keyColor = "blue";
        }
        {
          type = "host";
          key = "";
          keyColor = "blue";
        }
        {
          type = "cpu";
          key = "";
          keyColor = "blue";
        }
        {
          type = "gpu";
          key = "";
          keyColor = "magenta";
        }
        {
          type = "swap";
          key = "";
          keyColor = "magenta";
        }
        {
          type = "disk";
          key = "";
          keyColor = "red";
        }
        {
          type = "battery";
          key = "";
          keyColor = "red";
        }
        {
          type = "custom";
          format = "├─────────────────────────────────────────────────────────────┤";
	  keyColor = "green";
        }
        {
          type = "uptime";
          key = "";
          keyColor = "yellow";
        }
        {
          type = "terminal";
          key = "";
          keyColor = "yellow";
        }
        {
          type = "locale";
          key = "";
          keyColor = "yellow";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────────────┘";
	  keyColor = "green";
        }
        {
          type = "colors";
          paddingLeft = 24;
          symbol = "circle";
          block = {
            width = 10;
          };
        }
        "break"
      ];
    };
  };
}

