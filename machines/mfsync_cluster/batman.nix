{ config, lib, pkgs, ... }:

let
  start_mfsync_mesh = pkgs.writeScriptBin "start_mfsync_mesh" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.iproute}/bin/ip link set wlan0 down
    ${pkgs.iw}/bin/iw wlan0 set type ibss
    #ip link set dev wlan0 mtu 1532
    ${pkgs.wirelesstools}/bin/iwconfig wlan0 channel 3
    ${pkgs.iproute}/bin/ip link set wlan0 up
    ${pkgs.iw}/bin/iw wlan0 ibss join mfsync_mesh 2432
    #Frequency is 2.432. 0.0x should match with channel.
    ${pkgs.kmod}/bin/modprobe batman-adv
    ${pkgs.batctl}/bin/batctl if add wlan0
    ${pkgs.iproute}/bin/ip link set up dev wlan0
    ${pkgs.iproute}/bin/ip link set up dev bat0

    # enable multicast routing over wlan0 -> otherwise mfsync seems to fail
    ${pkgs.iproute}/bin/ip route add 224.0.0.0/4 dev wlan0
  '';

in
{
  environment.systemPackages = with pkgs; [
    start_mfsync_mesh
    pkgs.linuxPackages.batman_adv
    batctl
    alfred
  ];

  systemd.services.mfsync-mesh-network =
  {
    description = "mfsync-mesh-network batman-adv configuration";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${start_mfsync_mesh}/bin/start_mfsync_mesh";
      After=["network-online.target"];
      Wants=["network-online.target"];
    };
    wantedBy = [ "default.target" ];
  };
}
