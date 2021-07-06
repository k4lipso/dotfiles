let

  get_id = id : "10.5.5.1${id}";

  networkConfig = ip :
    ''
      [Match]
      Name = eth0
      [Network]
      Address =  10.5.5.1${ip}
      Gateway = 10.5.5.1
    '';
in
{
  network.description = "mfsync cluster";

  mfsync_test_01 =
    { ... }:
    {
      imports =
      [
        machines/mfsync_cluster/configuration.nix
        #machines/mfsync_cluster/camera.nix
      ];

      systemd.network = {
        enable = true;
        networks."eth0".extraConfig = networkConfig(get_id "01");
      };

      #networking.dhcpcd.enable = false;
      networking.nameservers = [ "1.1.1.1" ];


      networking.hostName = "mfsync_01";
    };
}
