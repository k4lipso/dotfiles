{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 5002 ];
  services.httpd.enable = true;
  services.httpd.adminAddr = "alice@example.org";
  services.httpd.virtualHosts.localhost.documentRoot = "/var/www/localhost";
}
