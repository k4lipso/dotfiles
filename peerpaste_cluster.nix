{
  network.description = "mfsync cluster";

  "rpi1" =
    { ... }:
    {
      imports =
      [
        machines/peerpaste_cluster/configuration.nix
      ];

      networking.hostName = "mfsync_01";
      deployment =
      {
        targetHost = "192.168.1.215";
      };
    };

  "rpi2" =
    { ... }:
    {
      imports =
      [
        machines/peerpaste_cluster/configuration.nix
      ];

      networking.hostName = "mfsync_02";
      deployment =
      {
        targetHost = "192.168.1.116";
      };
    };
}
