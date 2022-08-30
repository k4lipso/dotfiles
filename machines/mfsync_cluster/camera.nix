{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = false;
  hardware.firmware = [ pkgs.raspberrypiWirelessFirmware];
  boot.loader.grub.enable = false;

  boot.loader.raspberryPi.uboot.enable = true;
  boot.loader.raspberryPi.firmwareConfig = ''
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
