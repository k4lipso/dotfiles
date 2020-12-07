{ config, pkgs, ... }:

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

  services.nginx.virtualHosts."cache.dynamicdiscord.de" = {
    forceSSL = true;
    enableACME = true;
    locations."/".extraConfig = ''
      proxy_pass http://localhost:${toString config.services.nix-serve.port};
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    '';
  };
}
