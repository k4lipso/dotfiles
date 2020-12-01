# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
 AllowedKeys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCfDz5teTvRorVtpMj7i3pffD8W4Dn3Aiqre5L4WZq8Wc4bh2OjabGnIcDWpeToKf38n5m0d95OkIbARJwFN7KlbuQbmnIJ5n6pUj/zzRQ3dQTeSsUjkvdbSXVvTcDczMWwLixc/UKP1DMbiLHz5ZSywPTSH2l40lg74q7tSFGBwMy8uy4tsdp2d2sUIDfpvgGj3Pq+zkQHWyFR5BYyCLDfJMTQvGO0bEsbRIDOjkH8YVni46ds6sQKMgc+L2vPo8S3neFZBQRlERVRvIAzdLiBWqGkiw4YgWQA8ocTfWp9DVzW+BZiatc34+AX3KtLEF1Oz76YsKjBttSQL4myUucuskz2Bs7UYvAsDFlWyiJ43ayZNzvG63m1UVsAoq84IhNYsdkPhd+G1rtnG0KxPVAtn7RkAGt8t7ObU+6xWayHcpSteNeE+QyH9nNmJcXNNKfoOeP4vHUBrBTeURafw527yuZDOYknJmg3O+nkeGseIgBYgq/As4+dD6vhp03Y5chjU4/FC6nEjsGPRdfe2RZx+0cqJkLgdd1paGByUfPfaUKykw4TsCUAiDucRwBjU32MLslUbyzeEkjzOJzOD5Frif3jZZLxaNP2QcHRbTiiKkdn+WFJmjr3BdC60pm7hqvmDxl0UZcz9hDv3wZUALUc92TQXnWc8GicKdpQgRYDRQ== kalipso@c3d2.de" ];
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/home-manager.nix
      ../../modules/minimal.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/disk/by-id/ata-HGST_HMS5C4040BLE640_PL1331LAGZR8YH" "/dev/disk/by-id/ata-HGST_HMS5C4040BLE640_PL1331LAGZ7TTH" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.grub.version = 2;
  boot.zfs.requestEncryptionCredentials = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      # Use a different port than your usual SSH port!
      port = 2233;
      hostKeys = [ "/var/dropbear/initrd-openssh-key" ];
      # All users being a member of the "wheel" group are allowed to connect and enter the password.
      #authorizedKeys = with lib; concatLists (mapAttrsToList (name: user: if elem "wheel" user.extraGroups then user.openssh.authorizedKeys.keys else []) config.users.users);
      authorizedKeys = AllowedKeys;
    };
    postCommands = ''
      echo "zfs load-key -a; killall zfs" >> /root/.profile
    '';
  };

  networking.hostId = "8f5bb624"; 
  networking.usePredictableInterfaceNames = false;

  systemd.network = {
    enable = true;
    networks."eth0".extraConfig = import ./network_config.nix;
  };

  networking.dhcpcd.enable = false;

  services.openssh.enable = true;
  services.openssh.ports = [ 2222 ];
  users.users.root.openssh.authorizedKeys.keys = AllowedKeys;

  users.users.kalipso = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = AllowedKeys;
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

