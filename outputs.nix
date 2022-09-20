{ self
, utils
, nixpkgs-unstable
, nixpkgs-stable
, sops-nix
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
    };
  })) // {

    nixosConfigurations = import ./machines/configuration.nix (inputs // {
      inherit inputs;
    });
}
