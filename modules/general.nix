{ config, pkgs, ... }:

{
  systemd.services.systemd-user-sessions.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" "ntfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.hackrf.enable = true;

  environment.systemPackages = with pkgs; [
    nodejs
    node2nix
    arduino
    newsboat
    godot
    audacity
    wpa_supplicant
    chromium
    thunderbird
    vlc
    gimp
    firefox
    arandr rofi
    rxvt_unicode
    acpi
    dolphin
    gnupg
    ccls
    iw
    neovim
    gajim
    pass
    gparted
    mpv
    okular
    qtcreator
    feh
    steam
    element-desktop
    tdesktop
    wireshark
    tor-browser-bundle-bin
    signal-desktop
    sqlitebrowser
    libreoffice
    gource
    mumble
    pavucontrol
    qutebrowser
    remmina
    simplescreenrecorder
    gqrx
    sdrangel
    hackrf
    gqrx-portaudio
  ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.tlp.enable = true;

  #steam foo
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.allowUnfree = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.pathsToLink = [ "/libexec" ];

  # get some sleep dude...
  services.redshift.enable = true;
  location.latitude = 52.5200; # berlin
  location.longitude = 13.4049;

  # printing is cool
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  fonts.enableDefaultFonts = true;
  #fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];
}
