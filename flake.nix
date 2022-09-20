{
  description = "NixOps Environments";

  inputs.utils.url = "github:numtide/flake-utils";

  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";

    inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };

  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.sops-nix.url = "github:Mic92/sops-nix";

  inputs.mfsync.url = "github:k4lipso/mfsync";

  outputs = { ... } @ args: import ./outputs.nix args;
}
