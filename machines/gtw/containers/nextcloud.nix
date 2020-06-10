{ config, pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.tld";
    nginx.enable = true;
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "10.0.42.15"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbport = 5432;
      dbname = "nextcloud";
      adminpass = "test";
      #adminpassFile = "/path/to/admin-pass-file";
      adminuser = "root";
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
