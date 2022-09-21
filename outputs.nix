{ self
, utils
, nixpkgs-unstable
, nixpkgs-stable
, sops-nix
, deploy
, ...
} @inputs:

# filter i686-liux from defaultSystem to run nix flake check successfully
let filter_system = name: if name == utils.lib.system.i686-linux then false else true;
in (utils.lib.eachSystem (builtins.filter filter_system utils.lib.defaultSystems) ( system:
  let
    pkgs-stable = nixpkgs-stable.legacyPackages."${system}";
    pkgs-unstable = nixpkgs-unstable.legacyPackages."${system}";
  in
  {
    devShells.default = pkgs-unstable.callPackage ./shell.nix {
      inherit (sops-nix.packages."${pkgs-unstable.system}") sops-import-keys-hook ssh-to-pgp sops-init-gpg-key;
      inherit (deploy.packages."${pkgs-unstable.system}") deploy-rs;
    };
  })) // {

    nixosConfigurations = import ./machines/configuration.nix (inputs // {
      inherit inputs;
    });

    deploy = import ./machines/deploy.nix (inputs // {
      inherit inputs;
    });

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy.lib;
}
