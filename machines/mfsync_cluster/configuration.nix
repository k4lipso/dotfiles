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
      <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
      ../../modules/minimal.nix
      ./mfsync.nix
      ./batman.nix
    ];

  systemd.services.mfsync-daemon.enable = true;
  systemd.services.mfsync-mesh-network.enable = true;

  nixpkgs.system = "aarch64-linux";

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?

}

