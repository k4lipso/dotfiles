# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t480s>
      ./hardware-configuration.nix
      ../../modules/xserver.nix
      ../../modules/home-manager.nix
      ../../modules/general.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.hostId = "1423acbd";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";


  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  users.users.kalipso = {
    isNormalUser = true;
    home = "/home/kalipso";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  services.xserver.dpi = 144;
  # services.throttled.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
