{ config, pkgs, ... }:

{
  systemd.services.systemd-user-sessions.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = with pkgs; [
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
    gcc9
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
  environment.variables.EDITOR = "urxvt-unicode";

  fonts.enableDefaultFonts = true;
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];
}
