{ config, pkgs, ... }:

{
  systemd.services.systemd-user-sessions.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    wpa_supplicant
    htop
    chromium
    qutebrowser
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
    gcc9
    ccls
    cmake
    iw
    zsh
    oh-my-zsh
    rsync
    neovim
    gajim
    pass
    gparted
    nmap
    mpv
    killall
    direnv
    youtube-dl
    okular
    unzip
    zip
    qtcreator
    feh
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.tlp.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.pathsToLink = [ "/libexec" ];
  environment.variables.EDITOR = "urxvt";

  fonts.enableDefaultFonts = true;
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];

  #TimeZone
  time.timeZone = "Europe/Berlin";
}
