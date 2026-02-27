{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    codex-cli-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/laptop/default.nix
	home-manager.nixosModules.home-manager
	({ inputs, ... }: {
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.extraSpecialArgs = { inherit inputs; };
	  home-manager.backupFileExtension = "hm-bak";
	  home-manager.users.stalbar = import ./home/stalbar/home.nix;
	})
      ];
    };
  };
}
