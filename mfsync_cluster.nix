{
  network.description = "mfsync cluster";

  "mfsync_01" =
    { ... }:
    {
      imports =
      [
        machines/mfsync_cluster/configuration.nix
      ];

      networking.hostName = "mfsync_01";
      deployment =
      {
        targetHost = "192.168.1.215";
      };
    };

  "mfsync_02" =
    { ... }:
    {
      imports =
      [
        machines/mfsync_cluster/configuration.nix
      ];

      networking.hostName = "mfsync_02";
      deployment =
      {
        targetHost = "192.168.1.116";
      };
    };
}
