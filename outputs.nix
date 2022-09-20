{ self
, utils
, nixpkgs-unstable
, nixpkgs-stable
, sops-nix
, deploy
, ...
} @inputs:

(utils.lib.eachDefaultSystem ( system:
  let
    pkgs-stable = nixpkgs-stable.legacyPackages."${system}";
    pkgs-unstable = nixpkgs-unstable.legacyPackages."${system}";
  in
  {
    devShell = pkgs-unstable.callPackage ./shell.nix {
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
}
