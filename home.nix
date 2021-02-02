let
  secrets = import ./deployment_secrets.nix;
in
{
  network.description = "Home Network";

  "dsktp" =
    { ... }:
    {
      imports =
      [
        machines/dsktp/configuration.nix
      ];

      deployment =
      {
        targetHost = secrets.dsktp_ip;
      };
    };

  "gtw" =
    { ... }:
    {
      imports =
      [
        machines/gtw/configuration.nix
      ];

      deployment =
      {
        targetHost = secrets.gtw_ip;
      };
    };
}
