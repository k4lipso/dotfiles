# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      #<nixos-hardware/lenovo/thinkpad/t480s>
      ./hardware-configuration.nix
    ];

  systemd.services.systemd-user-sessions.enable = false;

  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    htop
    bmon
    wavemon
    rxvt_unicode
    acpi
    tree
    gnupg
    emacs
    gcc
    cmake
    iw
    zsh
    oh-my-zsh
    rsync
    pass
    nmap
    mpv
    killall
    direnv
    youtube-dl
    unzip
    zip
  ];

  networking = {
    hostName = "gtw1"; # Define your hostname.
    hostId = "13377331";

    interfaces = {
      eth0 = {
        name = "et0";
        useDHCP = false;
      };

      eth1 = {
        name = "eth1";
        ipv4.addresses = [ {
          address = "10.10.1.1";
          prefixLength = 24;
        } ];
        useDHCP = true;
      };
    };
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  users.users.kalipso = {
    isNormalUser = true;
    home = "/home/kalipso";
    initialPassword = "kalipso";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "man" ];
      theme = "robbyrussell";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
