{
  description = "NixOps Environments";

  inputs.utils.url = "github:numtide/flake-utils";

  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";

    inputs = {
      nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.mfsync.url = "github:k4lipso/mfsync";

  outputs = { self, utils, nixos-hardware, home-manager,
              mfsync, nixpkgs-stable, nixpkgs-unstable }@inputs:

  let
    pkgs-stable = nixpkgs-stable.legacyPackages.x86_64-linux;
  in
  {
    devShell.x86_64-linux = pkgs-stable.stdenv.mkDerivation
      {
        name = "nixops-20_09-env";
        NIX_PATH="nixpkgs=${pkgs-stable.path}";
        buildInputs = [ pkgs-stable.nixops ];
      };

    nixosConfigurations.nixos = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.inputs = inputs;
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-t480s
        ./machines/ltpt/configuration.nix
        home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kalipso = import ./modules/kalipso.nix;
        }
      ];
    };

  };
}
