# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/xserver.nix
      ../../modules/minimal.nix
      ../../modules/general.nix
      ../../modules/tor.nix
      ./mfsync_dhcp.nix
      ./dnscrypt.nix
      #./postgres.nix
    ];

  environment.systemPackages = with pkgs; [
    dhcpcd
    ncmpcpp
  ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.hostId = "1423acbd";

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  networking.firewall.allowedUDPPorts = [ 30001 ];
  networking.firewall.allowedTCPPorts = [ 8000 ];

  # Select internationalisation properties.
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  nixpkgs.config.allowUnsupportedSystem = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  users.users.kalipso = {
    isNormalUser = true;
    home = "/home/kalipso";
    extraGroups = [ "wheel" "vboxusers" ];
    shell = pkgs.zsh;
  };

  services.throttled.enable = false;

  services.picom.enable = true;
  services.picom.backend = "glx";
  services.picom.vSync = true;

  programs.ssh.startAgent = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
