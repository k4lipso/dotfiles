{ config, pkgs, inputs, ... }:

let
  Keys = import ../ssh_keys.nix;
in
{
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.secrets.ssh_kalipso = {};

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/xserver.nix
      ../../modules/minimal.nix
      ../../modules/general.nix
      ../../modules/tor.nix
    ];

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  #environment.systemPackages = with pkgs; [
  #  steam
  #];

  boot.initrd.kernelModules = [  "igb" ];

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      # Use a different port than your usual SSH port!
      port = 2233;
      hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" "/etc/secrets/initrd/ssh_host_ed25519_key" ];
      authorizedKeys = Keys.Kalipso;
    };
    postCommands = ''
      echo "zfs load-key -a; killall zfs" >> /root/.profile
    '';
  };


  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-pyjwt-1.7.1"
  ];


  nixpkgs.config.allowBroken = true;


#  services.weechat.enable = true;
#  services.tor.enable = true;

  programs.screen.screenrc = ''
    multiuser on
    acladd kalipso
  '';

  networking.hostName = "desktop"; # Define your hostname.
  networking.dhcpcd.enable = false;
  networking.hostId = "1337acbd";


  networking.firewall.allowedUDPPorts = [ 30001 ];
  networking.firewall.allowedTCPPorts = [ 8000 ];

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  services.openssh.enable = true;
  services.openssh.ports = [ 2222 ];
  services.openssh.passwordAuthentication = false;

  users.users.root.openssh.authorizedKeys.keys = Keys.Kalipso;

  programs.adb.enable = true; #enable android foo

  users.users.kalipso = {
    isNormalUser = true;
    home = "/home/kalipso";
    extraGroups = [ "wheel" "adbusers" ];
    openssh.authorizedKeys.keys = Keys.Kalipso;
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    #linuxPackages.nvidia_x11_vulkan_beta
    linuxPackages.nvidia_x11
    #cudatoolkit
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
