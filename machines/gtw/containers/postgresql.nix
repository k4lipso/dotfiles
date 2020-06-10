{ config, pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
      host  all  all 0.0.0.0/0 trust
    '';
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
     {
       name = "nextcloud";
       ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
     }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 5432 ];
}
