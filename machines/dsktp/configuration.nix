# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "05dabb7239254c0d9b2f314d7aa73923917bd1cd";
    ref = "master";
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      #<nixos-hardware/lenovo/thinkpad/t480s>
      ./hardware-configuration.nix
      "${home-manager}/nixos"
    ];

  systemd.services.systemd-user-sessions.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "desktop"; # Define your hostname.
  networking.networkmanager.enable = true;  # Disable networkmanager
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
#  networking.interfaces.enp0s25.useDHCP = true;
#  networking.interfaces.wlp3s0.useDHCP = true;
  networking.hostId = "1337acbd";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";


  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     wget
     vim
     git
     wpa_supplicant
     htop
     chromium
     thunderbird
     vlc
     gimp
     bmon
     wavemon
     emacs
     firefox
     arandr rofi
     rxvt_unicode
     acpi
     tree
     dolphin
     gnupg
     emacs
     gcc
     ccls
     cmake
     iw
     zsh
     oh-my-zsh
     rsync
     neovim
     #xorg.xbacklight
     gajim
     pass
     gparted
     nmap
     mpv
     killall
     direnv
     youtube-dl
   ];

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


  # programs.zsh.ohMyZsh = {
  #   enable = true;
  #   plugins = [ "git" "man" ];
  #   theme = "robbyrussell";
  #   syntaxHighlighting.enable = true;
  # };


  users.users.kalipso = {
    isNormalUser = true;
    home = "/home/kalipso";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager.users.kalipso =
  {
    programs.git = {
      enable = true;
      userName = "kalipso";
      userEmail = "kalipso@c3d2.de";
    };

    xdg.configFile."../.zshrc".source = ./dotfiles/zshrc;
    xdg.configFile."../.vimrc".source = ./dotfiles/vimrc;
    xdg.configFile."../.spacemacs".source = ./dotfiles/spacemacs;
    xdg.configFile."i3".source = ./dotfiles/i3;
    xdg.configFile."self".source = ./dotfiles/self;

  };

  home-manager.users.root =
  {
    programs.git = {
      enable = true;
      userName = "kalipso";
      userEmail = "kalipso@c3d2.de";
    };

    xdg.configFile."../.vimrc".source = ./dotfiles/vimrc;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.tlp.enable = true;

  # services.throttled.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.pathsToLink = [ "/libexec" ];
  environment.variables.EDITOR = "urxvt";

  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];

  #TimeZone
  time.timeZone = "Europe/Berlin";

  # Enable the X11 windowing system.
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver = {
    enable = true;

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
	i3blocks
      ];
    };
  };


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
