{
  description = "NixOps Environments";

  inputs.utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

  outputs = { self, nixpkgs, utils }:

  utils.lib.eachSystem [ "x86_64-linux" ]
    (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
  {
    devShell = pkgs.stdenv.mkDerivation
      {
        name = "nixops-20_09-env";
        NIX_PATH="nixpkgs=${pkgs.path}";
        buildInputs = [ pkgs.nixops ];
      };

  }
  );
}
