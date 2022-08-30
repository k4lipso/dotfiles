# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

let
 Keys = import ../../ssh_keys.nix;
 DeploymentSecrets = import ../../deployment_secrets.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      #./hardware-configuration.nix
      #<nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
      #<nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
      ../../modules/minimal.nix
      ../../modules/mfsync.nix
      ../../modules/dump.nix
      ./batman.nix
      ./camera.nix
    ];

  #issue 122993 - fixes missing kernel modules
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  boot.kernelPackages = pkgs.linuxPackages_rpi3;
  boot.loader.raspberryPi = {
    enable = true;
    version = 3;
  };

  systemd.services.mfsync-daemon.enable = true;
  systemd.services.mfsync-mesh-network.enable = true;
  systemd.services.evdump-daemon.enable = true;

  nixpkgs.system = "aarch64-linux";

  networking.firewall.enable = false;

  services.openssh.enable = true;
  services.openssh.ports = [ 22 ];
  users.users.root.openssh.authorizedKeys.keys = Keys.MfsyncCluster;
  services.openssh.passwordAuthentication = false;

  networking.firewall.allowedUDPPorts = [ 30001 ];
  networking.firewall.allowedTCPPorts = [ 8000 ];


  users.users.kalipso = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = Keys.MfsyncCluster;
    shell = pkgs.zsh;
  };

  fileSystems = {
    # Prior to 19.09, the boot partition was hosted on the smaller first partition
    # Starting with 19.09, the /boot folder is on the main bigger partition.
    # The following is to be used only with older images. Note such old images should not be considered supported anymore whatsoever, but if you installed back then, this might be needed
    /*
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    */
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?

}

