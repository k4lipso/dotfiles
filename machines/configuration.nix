{ self
, nixpkgs-unstable
, nixpkgs-stable
, sops-nix
, inputs
, nixos-hardware
, home-manager
, ...
}:
let
  nixosSystem = nixpkgs-unstable.lib.makeOverridable nixpkgs-unstable.lib.nixosSystem;
  nixosSystemStable = nixpkgs-stable.lib.makeOverridable nixpkgs-stable.lib.nixosSystem;
  baseModules = [
    # make flake inputs accessiable in NixOS
    { _module.args.inputs = inputs; }
    {
      imports = [
        ({ pkgs, ... }: {
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
        })

        sops-nix.nixosModules.sops
      ];

      environment.variables = { EDITOR = "vim"; VISUAL = "vim"; };
    }
  ];
  defaultModules = baseModules;
in
{
  celine = nixosSystem {
    system = "x86_64-linux";
    specialArgs.inputs = inputs;
    modules = defaultModules ++ [
      nixos-hardware.nixosModules.lenovo-thinkpad-t480s
      ./ltpt/configuration.nix
      home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.kalipso = import ../modules/kalipso.nix;
      }
    ];
  };

  desktop = nixosSystem {
    system = "x86_64-linux";
    specialArgs.inputs = inputs;
    modules = defaultModules ++ [
      ./dsktp/configuration.nix
      home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.kalipso = import ../modules/kalipso.nix;
      }
    ];
  };

  #htznr = nixosSystemStable {
  #
  #};
}
