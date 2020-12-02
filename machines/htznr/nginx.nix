{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme.acceptTerms = true;
  security.acme.email = "kalipso@c3d2.de";

  services.nginx.enable = true;
  services.nginx.virtualHosts."dynamicdiscord.de" = {
    #basicAuth = { test1 = "test2"; test3 = "test3"; };
    forceSSL = true;
    enableACME = true;
    root = "/var/www/dynamicdiscord.de";
  };

  services.nginx.recommendedProxySettings = true;
  services.nginx.recommendedGzipSettings = true;
  services.nginx.recommendedTlsSettings = true;
  services.nginx.recommendedOptimisation = true;

  services.nginx.virtualHosts."storage.dynamicdiscord.de" = {
    #basicAuth = { name = "password"; };
    forceSSL = true;
    enableACME = true;
  };

  services.nginx.virtualHosts."hydra.dynamicdiscord.de" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://localhost:3000";
  };

}
