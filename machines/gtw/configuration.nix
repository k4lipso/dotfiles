# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
 Keys = import ../../ssh_keys.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./networking.nix
      ../../modules/home-manager.nix
      ../../modules/minimal.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/disk/by-id/ata-ST3500418AS_9VMSREAL";
  #boot.supportedFilesystems = [ "zfs" ];
  #boot.loader.grub.version = 2;
  #boot.zfs.requestEncryptionCredentials = true;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      # Use a different port than your usual SSH port!
      port = 2233;
      hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" "/etc/secrets/initrd/ssh_host_ed25519_key" ];
      # All users being a member of the "wheel" group are allowed to connect and enter the password.
      #authorizedKeys = with lib; concatLists (mapAttrsToList (name: user: if elem "wheel" user.extraGroups then user.openssh.authorizedKeys.keys else []) config.users.users);
      authorizedKeys = Keys.Kalipso;
    };
    postCommands = ''
      echo "zfs load-key -a; killall zfs" >> /root/.profile
    '';
  };

  #networking.hostId = "8f5bb625";
  #networking.dhcpcd.enable = true;
  networking.usePredictableInterfaceNames = false;
  #networking.hostName = "gtw";

  #systemd.network = {
  #  enable = true;
  #  networks."eth0".extraConfig = import ./network_config.nix;
  #};

  #networking.dhcpcd.enable = false;

  services.openssh.enable = true;
  services.openssh.ports = [ 22 ];
  users.users.root.openssh.authorizedKeys.keys = Keys.Kalipso;
  services.openssh.passwordAuthentication = false;

  users.users.root.initialPassword = "test";

  users.users.kalipso = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = Keys.Kalipso;
    initialPassword = "test";
    shell = pkgs.zsh;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  #networking.useDHCP = false;
  #networking.interfaces.enp1s0.useDHCP = true;
  #networking.interfaces.enp2s0.useDHCP = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

