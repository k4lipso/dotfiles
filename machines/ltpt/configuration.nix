# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t480s>
      ./hardware-configuration.nix
      ../../modules/xserver.nix
      ../../modules/home-manager.nix
      ../../modules/minimal.nix
      ../../modules/general.nix
    ];

  environment.systemPackages = with pkgs; [
    dhcpcd
    ncmpcpp
  ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.hostId = "1423acbd";

  #networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # Select internationalisation properties.
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  users.users.kalipso = {
    isNormalUser = true;
    home = "/home/kalipso";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  services.throttled.enable = false;
  services.tor.enable = true;
  services.tor.torsocks.enable = true;
  services.tor.client.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "kalipso" ];


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
