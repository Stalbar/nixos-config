{ pkgs, ...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          right = 1;
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
	};
	color = "blue";
	separator = " ";
      };
      modules = [
        "title"
	"separator"
	"os"
	"host"
	"kernel"
	"uptime"
	"packages"
	"shell"
	"display"
	"de"
	"wm"
	"terminal"
	"cpu"
	"gpu"
	"memory"
	"break"
	"colors"
      ];
    };
  };
}
