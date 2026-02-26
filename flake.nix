{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpgks.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
	./configuration.nix
	home-manager.nixosModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.stalbar = { pkgs, ... }: {
	    home.username = "stalbar";
	    home.homeDirectory = "/home/stalbar";
	    home.stateVersion = "25.11";

	    programs.home-manager.enable = true;

	    home.packages = with pkgs; [
	      git
	    ];
          };
	}
      ];
    };
  };
}
