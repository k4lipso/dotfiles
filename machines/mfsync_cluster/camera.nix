{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;
  networking.wireless.enable = true;

  #boot.loader.generic-extlinux-compatible.enable = true;
  #boot.loader.grub.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_rpi3;

  #hardware.deviceTree = {
  #  enable = true;
  #  base = pkgs.deviceTree.raspberryPiDtbs;
  #  overlays = [ "${pkgs.deviceTree.raspberryPiOverlays}/w1-gpio.dtbo" ];
  #};

  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 3;
  boot.loader.raspberryPi.uboot.enable = true;
  boot.loader.raspberryPi.firmwareConfig = ''
    start_x=1
    gpu_mem=256
  '';

  boot.kernelModules = [ "bcm2835-v4l2" ];

  environment.systemPackages = with pkgs; [
    v4l-utils
    libv4l
    libraspberrypi
    raspberrypifw
  ];
}
