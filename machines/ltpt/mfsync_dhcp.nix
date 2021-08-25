{ config, lib, pkgs, ... }:

{
  networking.nat = {
    enable = true;
    internalInterfaces = [ "enp0s31f6" "wlp61s0" ];
    externalInterface = "wg0";
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "enp0s31f6" ];
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      option broadcast-address 10.5.5.255;
      option routers 10.5.5.1;
      option domain-name-servers 1.1.1.1, 1.0.0.1;
      subnet 10.5.5.0 netmask 255.255.255.0 {
        range 10.5.5.23 10.5.5.230;
      }
    '';
  };
}
