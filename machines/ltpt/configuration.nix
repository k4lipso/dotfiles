# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  #keep build time deps and be able to rebuild offline:
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    '';

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.secrets.postgres_password = {};

  imports =
    [
      ./hardware-configuration.nix
      ../../modules/xserver.nix
      ../../modules/minimal.nix
      ../../modules/general.nix
      ../../modules/tor.nix
      ./mfsync_dhcp.nix
      ./wireguard.nix
      ./dnscrypt.nix
      ./tor.nix
      ./nginx.nix
      ./postgres.nix
    ];

  environment.systemPackages = with pkgs; [
    qemu
    dhcpcd
    ncmpcpp
    docker-compose
    inputs.mfsync.packages.x86_64-linux.mfsync
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-pyjwt-1.7.1"
  ];


  nixpkgs.config.allowBroken = true;

  #nixpkgs.config.allowBroken = true;

  networking.hostName = "celine"; # Define your hostname.
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
    extraGroups = [ "wheel" "vboxusers" "docker" "plugdev" ];
    shell = pkgs.zsh;
  };

  services.throttled.enable = false;

  services.picom.enable = true;
  services.picom.backend = "glx";
  services.picom.vSync = true;

  programs.ssh.startAgent = true;

  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  virtualisation.docker.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
