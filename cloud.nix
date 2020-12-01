let
secrets = import ./deployment_secrets.nix;
in
{
  network.description = "Kalauser Net";

  "htznr" =
    { ... }:
    {
      imports =
      [
        machines/htznr/configuration.nix
      ];

      deployment =
      {
        targetHost = secrets.htznr_ip;
      };
    };

}
